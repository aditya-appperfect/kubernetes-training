resource "kubernetes_service" "client_time_app" {
  metadata {
    name = "client-time-app"
  }

  spec {
    selector = {
      app = "client-time-app"
    }

    port {
      protocol   = "TCP"
      port       = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_service" "server_time_app" {
  metadata {
    name = "server-time-app"
  }

  spec {
    selector = {
      app = "server-time-app"
    }

    port {
      protocol   = "TCP"
      port       = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      protocol   = "TCP"
      port       = 5432
      target_port = 5432
      node_port   = 32095
      name        = "postgres"
    }

    type = "NodePort"
  }
}
