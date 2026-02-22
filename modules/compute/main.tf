module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name = "dotnet-webapi-${var.env_prefix}"
  kubernetes_version = "1.33"
  enable_cluster_creator_admin_permissions = true

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnet_ids

  compute_config = {
    enabled = false
  }

  endpoint_public_access = true

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    aws-ebs-csi-driver = {}
  }

  eks_managed_node_groups = {
    webapi_group = {
      ami_type = var.ami_type
      instance_types = var.instance_types
      node_group_name = "webapi-group-${var.env_prefix}"

      min_size = 2
      max_size = 3
      desired_size = 3
    }
  }
}

# IAM role for the EBS CSI addon
resource "aws_iam_role" "ebs_csi_pod_identity" {
  name = "ebs-csi-pod-identity-role-${var.env_prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
    }]
  })
}

# Policy attachment for the EBS CSI role
resource "aws_iam_role_policy_attachment" "ebs-csi-attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_pod_identity.name
}

# Pod identity association for the EBS CSI service account
resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  role_arn        = aws_iam_role.ebs_csi_pod_identity.arn
  service_account = "ebs-csi-controller-sa"
}