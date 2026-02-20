env_prefix = "staging"
vpc_cidr = "10.2.0.0/16"
private_subnet_cidr_blocks = ["10.2.16.0/20", "10.2.32.0/20", "10.2.48.0/20"]
public_subnet_cidr_blocks = ["10.2.64.0/20", "10.2.80.0/20", "10.2.96.0/20"]
ami_type = "AL2023_x86_64_STANDARD"
instance_types = ["t3.small"]