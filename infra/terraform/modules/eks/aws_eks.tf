terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# add Access configuratipon for my user. Added manually now in EKS11

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      name           = "${var.cluster_name}-ng"
      desired_size   = var.ng_desired_size
      min_size       = var.ng_min_size
      max_size       = var.ng_max_size
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    metrics-server = {
      most_recent = true
    }
  }
  

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "eks_api_access" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Или ваш IP
  security_group_id = module.eks.cluster_security_group_id
}