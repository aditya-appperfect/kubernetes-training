FROM python:3.9-slim

WORKDIR /app

RUN pip install flask kubernetes

COPY flask-app.py /app

EXPOSE 5000

CMD ["python3", "flask-app.py"]
