include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  env          = "prod"
  region       = "ap-southeast-1"
  cluster_name = "prod-cluster"
  vpc_name     = "prod-vpc"
  vpc_cidr     = "10.2.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
  node_groups = {
    primary_nodes = {
      min_size       = 3
      max_size       = 6
      desired_size   = 3
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
    spot_nodes = {
      min_size       = 2
      max_size       = 4
      desired_size   = 2
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
}