
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
  }
}
data "aws_caller_identity" "current" {}
provider "aws" {
  region = var.region
}

module "eks" {
  for_each = var.eks_clusters

  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = each.value.cluster_name
  cluster_version = each.value.cluster_version
  vpc_id          = each.value.vpc_id
  subnet_ids      = each.value.subnet_ids
  authentication_mode = "API_AND_CONFIG_MAP"
  enable_irsa     = true
  eks_managed_node_groups = {
    for node_name, node_config in each.value.node_groups : node_name => {
      instance_types = node_config.instance_types
      min_size       = node_config.min_size
      max_size       = node_config.max_size
      desired_size   = node_config.desired_size
    }
  }
  access_entries = {
    "root" = {
      principal_arn = "arn:aws:iam::<ACCOUNT>:<USER>"
      type          = "STANDARD"
      kubernetes_groups = ["masters"]
    }
  } // TOBE REPLACE THSI
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    Environment = each.value.environment
  }
}

module "karpenter" {
  for_each = var.eks_clusters
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = each.value.cluster_name
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = each.value.environment
  }
}
