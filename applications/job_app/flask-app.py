from flask import Flask, request, jsonify, url_for, session, redirect
from kubernetes import client, config
from authlib.integrations.flask_client import OAuth
import secrets
import jwt
import os

app = Flask(__name__)

config.load_incluster_config()
# config.load_kube_config()


app.secret_key = secrets.token_hex(16)

app.config['KEYCLOAK_CLIENT_ID'] = 'flask-client'
app.config['KEYCLOAK_CLIENT_SECRET'] = 'kMwJ1LHwqdewo0qOInuAu8H6ThPFcwhd'
app.config['KEYCLOAK_BASE_URL'] = 'https://adityaappperfect.training/realms/my-realm/protocol/openid-connect'

oauth = OAuth(app)

keycloak = oauth.register(
    'keycloak',
    client_id=app.config['KEYCLOAK_CLIENT_ID'],
    client_secret=app.config['KEYCLOAK_CLIENT_SECRET'],
    authorize_url=f"{app.config['KEYCLOAK_BASE_URL']}/auth",
    authorize_params=None,
    access_token_url=f"{app.config['KEYCLOAK_BASE_URL']}/token",
    refresh_token_url=None,
    api_base_url=app.config['KEYCLOAK_BASE_URL'],
    client_kwargs={'scope': 'openid email profile', 'verify': False},
    jwks_uri="https://adityaappperfect.training/realms/my-realm/protocol/openid-connect/certs"
)

@app.route('/login')
def login():
    nonce = secrets.token_urlsafe(16)
    session['nonce'] = nonce
    return keycloak.authorize_redirect(redirect_uri=url_for('authorized', _external=True).replace('/callback', '/api/callback'), nonce=nonce)

@app.route('/logout')
def logout():
    session.clear()
    keycloak_logout_url = (f"{app.config['KEYCLOAK_BASE_URL']}/logout?redirect_uri={url_for('index', _external=True).replace('/index', '/api/index')}&client_id={app.config['KEYCLOAK_CLIENT_ID']}&prompt=login")

    return redirect(keycloak_logout_url)


@app.route('/callback')
def authorized():
    token = keycloak.authorize_access_token()

    if not token:
        return 'Access denied: error={}'.format(request.args['error_description'])

    id_token = token.get('id_token')
    nonce = session.get('nonce')

    if not nonce:
        return 'Error: Missing nonce in session'
    
    try:
        decoded_token = jwt.decode(id_token, options={"verify_signature": False})
    except Exception as e:
        return f"Error decoding token: {e}"

    session['keycloak_token'] = token
    session['user'] = decoded_token
    
    return redirect("/api/")


def list_jobs(namespace):
    job_api = client.BatchV1Api()
    try:
        jobs = job_api.list_namespaced_job(namespace=namespace)
        job_list = [{"name": job.metadata.name} for job in jobs.items]
        return jsonify(job_list)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    
def create_job(name, image, namespace, command):
    if not name or not image:
        missing_fields = []
        if not name:
            missing_fields.append('name')
        if not image:
            missing_fields.append('image')
        return jsonify({"error": f"Missing required fields: {', '.join(missing_fields)}"}), 400
    
    core_api = client.CoreV1Api()
    namespacesList = core_api.list_namespace()
    namespace_list = [ns.metadata.name for ns in namespacesList.items]
    if namespace not in namespace_list:
        namespace_obj = client.V1Namespace(metadata=client.V1ObjectMeta(name=namespace))
        core_api.create_namespace(body=namespace_obj)

    job_api = client.BatchV1Api()
    
    if any(job['name'] == name for job in list_jobs(namespace).get_json()):
        return jsonify({"error": f"Job '{name}' already exists in the '{namespace}' namespace."}), 400
    
    try:
        job = client.V1Job(
            metadata=client.V1ObjectMeta(name=name),
            spec=client.V1JobSpec(
                template=client.V1PodTemplateSpec(
                    spec=client.V1PodSpec(
                        containers=[
                            client.V1Container(name=name, image=image, command=command)
                        ],
                        restart_policy='Never'
                    )
                )
            )
        )
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    job_api.create_namespaced_job(namespace=namespace, body=job)
    return jsonify({"message": f"Job {name} created"}), 201



def delete_job(name, namespace):    
    if not name:
        return jsonify({"error": "name field is missing"}), 400
    
    core_api = client.CoreV1Api()

    namespacesList = core_api.list_namespace()
    namespace_list = [ns.metadata.name for ns in namespacesList.items]
    
    if namespace not in namespace_list:
        return jsonify({"message": f"Namespace '{namespace}' not found"}), 400

    job_api = client.BatchV1Api()
    
    if not any(job['name'] == name for job in list_jobs(namespace).get_json()):
        return jsonify({"error": f"Job '{name}' do not exists in the '{namespace}' namespace."}), 400
    
    job_api.delete_namespaced_job(name=name, namespace=namespace)
    
    return jsonify({"message": f"Job {name} deleted"}), 200


@app.route('/', methods=['GET', 'POST'])
def handle_return_joblist():
    if 'keycloak_token' not in session:
        return redirect(url_for('login').replace('/login', '/api/login'))
    
    if request.method == 'POST':
        data = request.json
        namespace = data.get('namespace', 'default')
    else: 
        namespace = 'default'
    return list_jobs(namespace)


@app.route('/index', methods=['GET'])
def index():
    return jsonify({"message": "Login"}), 200


@app.route('/job', methods=['POST'])
def handle_create_or_delete_jobs():
    action = request.headers.get('X-Action')
    print(f'X-Action: {action}')
    
    if not action:
        return jsonify({"error": "Missing 'X-Action' header"}), 400

    data = request.json
    name = data.get('name', None)
    image = data.get('image', None)
    namespace = data.get('namespace', 'default')
    command = data.get('command', [])

    if action == 'create':
        return create_job(name, image, namespace, command)
    elif action == 'delete':
        return delete_job(name, namespace)
    else:
        return jsonify({"error": "Invalid 'X-Action' header value. Must be 'create' or 'delete'."}), 400


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
