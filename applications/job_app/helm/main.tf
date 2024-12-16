provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "job_manager" {
  name       = "job-manager"
  namespace  = "default"
  chart      = "./job-manager-1.0.0.tgz"
}
