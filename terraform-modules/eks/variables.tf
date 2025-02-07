variable "region" {}
variable "env" {}
variable "cluster_name" {}
variable "cluster_version" {
  type = string
  default = "1.29"
}
variable "node_groups" {
  description = "EKS managed node groups"
  type = map(object({
    min_size     = number
    max_size     = number
    desired_size = number
    instance_types = list(string)
    capacity_type  = string
  }))
}