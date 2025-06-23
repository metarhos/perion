variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" # Change to your region
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "hello-world-node" # Match your ECR repo name
}