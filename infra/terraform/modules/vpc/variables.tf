variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "Name prefix for resources (3-30 chars, alphanumeric + hyphens)"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/stage/prod)"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR (must be /16 or larger)"
  default = "10.0.0.0/16" # 65,536
  
  validation {
    condition     = can(cidrnetmask(var.cidr_block)) && tonumber(split("/", var.cidr_block)[1]) <= 16
    error_message = "Must be a valid IPv4 CIDR with mask <=16 (e.g., 10.0.0.0/16)."
  }
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default = ["10.0.1.0/24", "10.0.2.0/24"] # 256
  
  validation {
    condition     = alltrue([for s in var.private_subnets : can(cidrsubnet(s, 0, 0))])
    error_message = "All subnets must be valid CIDRs."
  }
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default = ["10.0.101.0/24", "10.0.102.0/24"] # 256
  
  validation {
    condition     = alltrue([for s in var.public_subnets : can(cidrsubnet(s, 0, 0))])
    error_message = "All subnets must be valid CIDRs."
  }
}