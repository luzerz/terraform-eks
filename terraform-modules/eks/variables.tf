variable "region" {}

variable "eks_clusters" {
  description = "Map of EKS clusters and their configurations"
  type = map(object({
    cluster_name    = string
    cluster_version = string
    vpc_id          = string
    subnet_ids      = list(string)
    environment     = string
    node_groups     = map(object({
      instance_types = list(string)
      min_size       = number
      max_size       = number
      desired_size   = number
      capacity_type  = string
    }))
  }))
}

variable "irsa_roles" {
  description = "IAM Roles for Service Accounts in EKS clusters"
  type = map(object({
    name            = string
    cluster_key     = string # Matches key in `eks_clusters`
    namespace       = string
    service_account = string
    policies        = list(object({
      name       = string
      statements = list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      }))
    }))
  }))
}
