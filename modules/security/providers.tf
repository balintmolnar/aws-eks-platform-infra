terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes = {
    host                    = var.cluster_endpoint
    cluster_ca_certificate  = base64decode(var.cluster_certificate_authority_data)
    token                   = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "aws" {
  default_tags {
    tags = {
      Terraform = "true"
      Environment = var.env_prefix
    }
  }
}