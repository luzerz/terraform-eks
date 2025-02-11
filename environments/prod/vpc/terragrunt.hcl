include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
   source = "${get_parent_terragrunt_dir()}/terraform-modules//vpc"
}

inputs = {
  env          = "dev"
  region       = "ap-southeast-1"
  vpc_name     = "dev-vpc"
  vpc_cidr     = "10.1.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
}