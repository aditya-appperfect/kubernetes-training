resource "kubernetes_ingress_v1" "client_ingress" {
  metadata {
    name = "client-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
      "kubernetes.io/ingress.class" = "nginx" 
    }
  }

  spec {
    tls {
      hosts = ["adityaappperfect.training"]
      secret_name = "secret-timeapp-tls"
    }

    rule {
      host = "adityaappperfect.training"

      http {
        dynamic "path" {
          for_each = local.paths

          content {
            path = path.value.path
            path_type = "ImplementationSpecific"
            backend {
              service {
                name = path.value.name
                port {
                  number = path.value.port
                }
              }
            }
          }
        }
      }
    }
  }
}
