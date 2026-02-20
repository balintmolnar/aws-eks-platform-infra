env_prefix = "prod"
vpc_cidr = "10.3.0.0/16"
private_subnet_cidr_blocks = ["10.3.16.0/20", "10.3.32.0/20", "10.3.48.0/20"]
public_subnet_cidr_blocks = ["10.3.64.0/20", "10.3.80.0/20", "10.3.96.0/20"]
ami_type = "AL2023_x86_64_STANDARD"
instance_types = ["t3.small"]