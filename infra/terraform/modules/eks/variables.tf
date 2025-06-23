variable "cluster_name" {
  type        = string
  description = "Name prefix for resources (3-30 chars, alphanumeric + hyphens)"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/stage/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS cluster"
}

variable "ng_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "ng_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "ng_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.small"]
  description = "EC2 instance types for the node group"
}

variable "node_capacity_type" {
  type        = string
  default     = "SPOT" # test env, save money. For prod on-demand
  description = "Capacity type for nodes: ON_DEMAND or SPOT"
}
