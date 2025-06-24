# TODO: add/remove validation for variables where it need in all project

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = contains([
      "us-east-1", "us-east-2", "us-west-1", "us-west-2",
      "eu-west-1", "eu-central-1", "ap-southeast-1"
    ], var.region)
    error_message = "Invalid AWS region. Allowed: us-east-1, us-west-2, etc."
  }
}

variable "cluster_name" {
  type        = string
  description = "Project name (3-30 chars)"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.cluster_name))
    error_message = "Must be 3-30 chars: a-z, 0-9, hyphens."
  }
}

variable "environment" {
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Must be dev/stage/prod."
  }
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR (must be /16 or larger)"
  default = "10.0.0.0/16" # 65,536 total IPs
  
  validation {
    condition     = can(cidrnetmask(var.cidr_block)) && tonumber(split("/", var.cidr_block)[1]) <= 16
    error_message = "Must be a valid IPv4 CIDR with mask ≤16 (e.g., 10.0.0.0/16)."
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

# Use mock for terrafom plan before real EKS
variable "use_mock" {
  description = "Use mock providers or real AWS"
  type        = bool
  default     = false
}
 
variable "repo_name" {
  description = "ECR repo name"
  type        = string
  default     = "pavel-hello-world-node-images"
}