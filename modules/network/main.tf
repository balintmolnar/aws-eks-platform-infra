data "aws_availability_zones" "available_azs" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "dotnet-webapi-vpc-${var.env_prefix}"
  cidr = var.vpc_cidr
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks

  azs = data.aws_availability_zones.available_azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "${var.env_prefix}"
    "kubernetes.io/cluster/dotnet-webapi-${var.env_prefix}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/dotnet-webapi-${var.env_prefix}" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/dotnet-webapi-${var.env_prefix}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}