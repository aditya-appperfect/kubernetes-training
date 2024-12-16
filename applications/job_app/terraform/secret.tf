resource "kubernetes_secret" "nginx_config_secret" {
  metadata {
    name      = "nginx-config-secret"
    namespace = "default"
  }

  data = {
    "nginx.conf" = file("./nginx.conf")
  }
}

resource "kubernetes_secret" "secret_tls" {
  metadata {
    name = "secret-tls" 
  }

  data = {
    "tls.crt" = file("./server.crt")

    "tls.key" = file("./server.key")
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "ca_tls" {
  metadata {
    name = "ca-tls" 
  }

  data = {
    "ca.crt" = file("./rootCA.crt")
  }
}
