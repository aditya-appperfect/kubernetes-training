resource "kubernetes_ingress_v1" "ingress_application" {
  metadata {
    name = "ingress-application"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    tls {
      hosts      = ["adityaappperfect.training"]
      secret_name = "secret-tls"
    }

    rule {
      host = "adityaappperfect.training"

      http {
        path {
          path      = "/"
          path_type = "Exact"

          backend {
            service {
              name = "nginx-flask-service"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path      = "/job"
          path_type = "Exact"

          backend {
            service {
              name = "nginx-flask-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
