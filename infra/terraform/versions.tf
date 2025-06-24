terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
    kubernetes = { 
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
    }
    helm = {
      source  = "hashicorp/helm" # https://registry.terraform.io/providers/hashicorp/helm/latest
      version = "~> 3.0.0"
    }
  }
}