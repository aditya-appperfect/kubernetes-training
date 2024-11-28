resource "kubernetes_deployment" "client_time_app" {
  metadata {
    name = "client-time-app"
    labels = {
      app = "client-time-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client-time-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "client-time-app"
        }
      }

      spec {
        container {
          name  = "client-time-app"
          image = "adityaappperfect/21-time-app-client:latest"
          
          port {
            container_port = 3000
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

resource "kubernetes_deployment" "server_time_app" {
  metadata {
    name = "server-time-app"
    labels = {
      app = "server-time-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "server-time-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "server-time-app"
        }
      }

      spec {
        container {
          name  = "server-time-app"
          image = "adityaappperfect/21-time-app-server:latest"

          env {
            name = "DB_HOST"
            value = "postgres"
          }
          env {
            name = "DB_PORT"
            value = "5432"
          }
          env {
            name = "DB_USER"
            value = "postgres"
          }
          env {
            name = "DB_PASSWORD"
            value = "App4ever#"
          }
          env {
            name = "DB_PASSWORD"
            value = "devopstestdb"
          }
          
          port {
            container_port = 8080
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

resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:13"

          env {
            name = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "App4ever#"
          }
          env {
            name = "POSTGRES_DB"
            value = "devopstestdb"
          }

          port {
            container_port = 5432
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
