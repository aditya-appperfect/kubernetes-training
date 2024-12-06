resource "kubernetes_deployment" "nginx_flask_deployment" {
  metadata {
    name      = "nginx-flask"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-flask"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }

          volume_mount {
            name      = "nginx-config-volume"
            mount_path = "/etc/nginx/conf.d/nginx.conf"
            sub_path  = "nginx.conf"
          }
          volume_mount {
            name      = "secret-tls"
            mount_path = "/etc/ssl/certs/tls.crt"
            sub_path  = "tls.crt"
          }
          volume_mount {
            name      = "secret-tls"
            mount_path = "/etc/ssl/certs/tls.key"
            sub_path  = "tls.key"
          }
        }

        container {
          name  = "flask"
          image = "adityaappperfect/job-creation-app:latest"
          port {
            container_port = 5000
          }
        }

        volume {
          name = "nginx-config-volume"
          secret {
            secret_name = kubernetes_secret.nginx_config_secret.metadata[0].name
          }
        }

        volume {
          name = "secret-tls"
          secret {
            secret_name = kubernetes_secret.secret_tls.metadata[0].name
          }
        }
      }
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

resource "kubernetes_deployment" "keycloak_deployment" {
  metadata {
    name      = "keycloak"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "keycloak"
      }
    }

    template {
      metadata {
        labels = {
          app = "keycloak"
        }
      }

      spec {
        container {
          name  = "keycloak"
          image = "quay.io/keycloak/keycloak:latest"
          args = ["start-dev"]
          env {
            name  = "KC_BOOTSTRAP_ADMIN_USERNAME"
            value = "admin"
          }
          env {
            name  = "KC_BOOTSTRAP_ADMIN_PASSWORD"
            value = "admin"
          }
          env {
            name  = "PROXY_ADDRESS_FORWARD"
            value = "true"
          }
          env {
            name  = "KC_HTTP_ENABLED"
            value = "false"
          }
          env {
            name  = "KC_HTTPS_CERTIFICATE_FILE"
            value = "./tls.crt"
          }
          env {
            name  = "KC_HTTPS_CERTIFICATE_KEY_FILE"
            value = "./tls.key"
          }
          port {
            container_port = 8080
          }
          volume_mount {
            name      = "secret-tls"
            mount_path = "/tls.crt"
            sub_path  = "tls.crt"
          }
           volume_mount {
            name      = "secret-tls"
            mount_path = "/tls.key"
            sub_path  = "tls.key"
          }
        }
        volume {
          name = "secret-tls"
          secret {
            secret_name = kubernetes_secret.secret_tls.metadata[0].name
          }
        }
      }
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
