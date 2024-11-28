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
        path {
          path = "/client(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "client-time-app"
              port {
                number = 3000
              }
            }
          }
        }

        path {
          path = "/server(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "server-time-app"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
