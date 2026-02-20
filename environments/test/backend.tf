terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-9574"
    key = "environments/test/terraform.tfstate"
    region = "eu-central-1"
  }
}