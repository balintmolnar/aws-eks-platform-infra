terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-9574"
    key = "environments/prod/terraform.tfstate"
    region = "eu-central-1"
    use_lockfile = true
  }
}