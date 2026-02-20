terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "3.0.1"
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

provider "kubernetes" {
  host                    = var.cluster_endpoint
  cluster_ca_certificate  = base64decode(var.cluster_certificate_authority_data)
  token                   = data.aws_eks_cluster_auth.cluster.token
}
