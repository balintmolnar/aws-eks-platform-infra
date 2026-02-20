resource "kubernetes_namespace_v1" "dotnet-app" {
  metadata {
    name = "dotnet-app"

    labels = {
      name = "dotnet-app"
      terraform = "true"
    }
  }
}

resource "kubernetes_manifest" "aws_secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind = "SecretStore"
    metadata = {
      name = "aws-secretsmanager"
      namespace = "dotnet-app"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region = "eu-central-1"
        }
      }
    }
  }

  depends_on = [
    var.cluster_name,
    var.external_secrets_operator,
    kubernetes_namespace_v1.dotnet-app
  ]
}

resource "kubernetes_manifest" "postgres_external_secret" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind = "ExternalSecret"
    metadata = {
      name = "postgres-db-password"
      namespace = "dotnet-app"
    }
    spec = {
      refreshInterval = "1h"
      secretStoreRef = {
        name = "aws-secretsmanager"
        kind = "SecretStore"
      }
      target = {
        name = "db-password-k8s"
        creationPolicy = "Owner"
      }
      data = [
        {
          secretKey = "password"
          remoteRef = {
            key = var.db_secret_name
          }
        }
      ]
    }
  }

  depends_on = [kubernetes_manifest.aws_secret_store]
}