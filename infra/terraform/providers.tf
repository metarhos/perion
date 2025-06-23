# Default AWS provider (real)
provider "aws" {
  alias       = "real"
  region = var.region
  # credentials or via ~/.aws/credentials(config) or env (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN) or SSO for local usage 
  # or ec-2 with IAM, or OIDC for pipelines
}

# Beautifull AWS provider mock
provider "aws" {
  alias  = "mock"
  region = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  
  endpoints {
    eks = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}


provider "kubernetes" {
  alias       = "real"
  host                   = module.eks.cluster_endpoint  
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data) # CA cert for TLS verification
  
  # Authentication using AWS CLI
  exec { 
    api_version = "client.authentication.k8s.io/v1beta1"  
    command     = "aws"  
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]  
  }
}

# provider "kubernetes" {
#   alias       = "mock"
#   config_path = "kubeconfig-mock.yaml"
# }

provider "helm" {
  alias = "real"
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

