include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  env          = "dev"
  region       = "ap-southeast-1"
  cluster_name = "dev-cluster"
  vpc_name     = "dev-vpc"
  vpc_cidr     = "10.1.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  node_groups = {
    worker_nodes = {
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
    spot_nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
    }
  }
}