resource "kubernetes_cluster_role" "job_reader" {
  metadata {
    name = "job-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["list", "get", "create", "delete"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["list", "create", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "job_reader_binding" {
  metadata {
    name = "job-reader-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = "job-reader"
    api_group = "rbac.authorization.k8s.io"
  }
}

