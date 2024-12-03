resource "kubernetes_service" "nginx_flask_service" {
  metadata {
    name = "nginx-flask-service"
  }

  spec {
    selector = {
      app = "nginx-flask"
    }

    port {
      name       = "nginx-port"
      protocol   = "TCP"
      port       = 80
      target_port = 80
    }

    port {
      name       = "flask-port"
      protocol   = "TCP"
      port       = 5000
      target_port = 5000
    }
  }
}
