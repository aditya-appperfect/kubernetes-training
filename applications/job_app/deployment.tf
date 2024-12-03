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