terraform {
  source = "terraform-modules//${path_relative_to_include()}"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-bucket"
    key            = "terraform/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}