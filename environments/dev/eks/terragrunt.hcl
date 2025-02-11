include "root" {
  path = find_in_parent_folders("root.hcl")
}
terraform {
   source = "${get_parent_terragrunt_dir()}/terraform-modules//eks"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
        vpc_id = "vpc-1234"
        private_subnets= ["sg-1234","sg-1230","sg-1235"]
  }
}


inputs = {
  region = "ap-southeast-1"
  eks_clusters = {
    "dev-cluster" = {
      cluster_name    = "dev-cluster"
      cluster_version = "1.32"
      vpc_id          = dependency.vpc.outputs.vpc_id
      subnet_ids      = dependency.vpc.outputs.private_subnets
      environment     = "dev"

      node_groups = {
        "primary" = {
          instance_types = ["t3.micro"]
          min_size       = 1
          max_size       = 3
          desired_size   = 2
          capacity_type  = "ON_DEMAND"
        },
        "spot" = {
          instance_types = ["t3.micro"]
          min_size       = 2
          max_size       = 5
          desired_size   = 3
          capacity_type  = "SPOT"
        }
      }
    }
  }

  irsa_roles = {
    "eks-irsa-role-dev" = {
      name            = "eks-irsa-role-dev"
      cluster_key     = "dev-cluster"
      namespace       = "kube-system"
      service_account = "aws-iam"

      policies = [
        {
          name = "S3AccessPolicy"
          statements = [
            {
              Effect   = "Allow"
              Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
              Resource = ["arn:aws:s3:::dev-eks-storage", "arn:aws:s3:::dev-eks-storage/*"]
            }
          ]
        },
        {
          name = "ECRAccessPolicy"
          statements = [
            {
              Effect   = "Allow"
              Action   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer"]
              Resource = ["*"]
            }
          ]
        }
      ]
    }
  }
}