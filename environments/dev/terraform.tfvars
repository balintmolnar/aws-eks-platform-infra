env_prefix = "dev"
vpc_cidr = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]
public_subnet_cidr_blocks = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
ami_type = "AL2023_x86_64_STANDARD"
instance_types = ["t3.small"]
exclude_secret_store = false