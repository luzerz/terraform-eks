include "root" {
  path = find_in_parent_folders("root.hcl")
}
terraform {
   source = "${get_parent_terragrunt_dir()}/terraform-modules//s3"
}

inputs = {
  env = "dev"
}