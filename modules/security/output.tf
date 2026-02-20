output "db_secret_name" {
  value = aws_secretsmanager_secret.db_secret.name
}

output "db_password_secret_string" {
  value = aws_secretsmanager_secret_version.db_password_version.secret_string
}

output "external_secrets_operator" {
  value = helm_release.external_secrets_operator
}
