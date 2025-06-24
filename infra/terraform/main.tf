module "vpc" {
  source = "./modules/vpc"

  cluster_name = var.cluster_name
  region       = var.region
  environment  = var.environment
  cidr_block   = var.cidr_block
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  providers = {
    aws = aws.real
  }
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
  environment  = var.environment

  providers = {
    aws        = aws.real
  }
}

module "ecr" { # guys, clean your ECR) here's a lot of old repos. Save money! :)
  source      = "./modules/ecr"
  environment = var.environment
  repository_name = var.repo_name 

  providers = {
    aws = aws.real
  }
}

module "aws_iam" {
  depends_on = [module.ecr]  
  source = "./modules/aws_iam"

  region = var.region
  ecr_repository_name = module.ecr.repository_name

  providers = {
    aws = aws.real
  }
}

# module "argocd" {
#   depends_on = [module.eks] 
#   source = "./modules/argocd"

#   providers = {
#     helm        = helm.real
#     kubernetes  = kubernetes.real
#   }
# }
