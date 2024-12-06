resource "kubernetes_ingress_v1" "ingress_application" {
  metadata {
    name = "ingress-application"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target": "/$1"
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
          path      = "/(.*)"
          path_type = "ImplementationSpecific"

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
