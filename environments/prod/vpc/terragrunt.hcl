include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
   source = "${get_parent_terragrunt_dir()}/terraform-modules//vpc"
}

inputs = {
  env          = "dev"
  region       = "ap-southeast-1"
  vpc_name     = "prod-vpc"
  vpc_cidr     = "10.2.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
}