
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  tags = {
    "kubernetes.io/cluster/${var.env}-cluster" = "shared"
    Terraform   = "true"
    Environment = var.env
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.env}-cluster" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}