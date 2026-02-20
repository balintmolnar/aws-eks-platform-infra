module "network" {
  source = "../../modules/network"
  vpc_cidr = var.vpc_cidr
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  env_prefix = var.env_prefix
}

module "compute" {
  source = "../../modules/compute"
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  env_prefix = var.env_prefix
  ami_type = var.ami_type
  instance_types = var.instance_types
}

module "database" {
  source = "../../modules/database"
  cluster_certificate_authority_data = module.compute.cluster_certificate_authority_data
  cluster_endpoint = module.compute.cluster_endpoint
  cluster_name = module.compute.cluster_name
  db_password_secret_string = module.security.db_password_secret_string
}

module "security" {
  source = "../../modules/security"
  cluster_certificate_authority_data = module.compute.cluster_certificate_authority_data
  cluster_endpoint = module.compute.cluster_endpoint
  cluster_name = module.compute.cluster_name
  env_prefix = var.env_prefix
}

module "app-config" {
  source = "../../modules/app-config"
  cluster_certificate_authority_data = module.compute.cluster_certificate_authority_data
  cluster_endpoint = module.compute.cluster_endpoint
  cluster_name = module.compute.cluster_name
  db_secret_name = module.security.db_secret_name
  external_secrets_operator = module.security.external_secrets_operator
}