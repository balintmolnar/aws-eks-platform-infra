terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-9574"
    key = "environments/dev/terraform.tfstate"
    region = "eu-central-1"
  }
}