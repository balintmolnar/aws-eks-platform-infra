resource "helm_release" "postgreSQL" {
  chart = "postgresql"
  name  = "postgresql"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  namespace = "database"
  create_namespace = true

  set = [
    {
      name = "auth.database"
      value = "tododb"
    },
    {
      name = "auth.username"
      value = "dbuser"
    },
    {
      name = "auth.password"
      value = var.db_password_secret_string
    },
    {
      name = "global.defaultStorageClass"
      value = "ebs-sc"
    },
    {
      name = "architecture"
      value = "replication"
    }
  ]

  depends_on = [
    var.cluster_name,
    kubernetes_namespace_v1.database
  ]

  timeout = 600
  wait = true
}

resource "kubernetes_storage_class_v1" "ebs-sc" {
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy = "Delete"
  metadata {
    name = "ebs-sc"
  }

  depends_on = [var.cluster_name]
}

resource "kubernetes_namespace_v1" "database" {
  metadata {
    name = "database"

    labels = {
      name = "database"
      terraform = "true"
    }
  }
}