terraform {
  backend "s3" {}
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.0.1"

  bucket = "${var.env}-eks-storage"
  //acl    = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Name        = "${var.env}-eks-storage"
    Environment = var.env
  }
}

