locals {
  paths = [
    {
      path     = "/client(/|$)(.*)"
      name  = "client-time-app"
      port     = 3000
    },
    {
      path     = "/server(/|$)(.*)"
      name  = "server-time-app"
      port     = 8080
    }
  ]
}