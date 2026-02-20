
resource "random_password" "db_password" {
  length = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.env_prefix}/postgres/password"
  description = "PostgreSQL password for dotnet-webapi"

  tags = {
    Terraform = "true"
    Environment = "${var.env_prefix}"
  }
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}

resource "helm_release" "external_secrets_operator" {
  chart = "external-secrets"
  name  = "external-secrets"
  namespace = "external-secrets"
  create_namespace = true
  repository = "https://charts.external-secrets.io"

  depends_on = [var.cluster_name]
}

# IAM role for external secrets operator
resource "aws_iam_role" "eso_pod_identity" {
name = "eso-pod-identity-role-${var.env_prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
    }]
  })
}

# Policy attachment for external secrets operator role
resource "aws_iam_role_policy_attachment" "eso-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess"
  role       = aws_iam_role.eso_pod_identity.name
}

# Pod identity association for the external secrets operator service account
resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = var.cluster_name
  namespace       = "external-secrets"
  role_arn        = aws_iam_role.eso_pod_identity.arn
  service_account = "external-secrets"
}
