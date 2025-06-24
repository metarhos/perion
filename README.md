This project contains IaC based on Terraform and Kubernetes resources to deploy a high-availability Node.js application.

## ✅ Implemented

### Infrastructure
- VPC with public/private subnets across 2 AZs
- EKS Cluster with managed node groups
- IAM role for GitHub Actions with OIDC federation
- ECR repository for Docker images

### Application
- Node.js application deployed as Helm chart
- HPA with CPU target utilization at 80%
- PodDisruptionBudget and podAntiAffinity for HA
- Readiness, liveness, and startup probes
- Morning warmUp 

### CI/CD
- GitHub Actions workflow:
  - Unit test workflow on PRs
  - Build & push Docker image to ECR
  - Update Helm values after build
- Security:
  - GitHub OIDC authentication with least-privilege IAM role

## 🚧 Work In Progress

- ❌ ArgoCD is not fully installed due to Terraform Helm/Kubernetes provider issues
- ❌ Logging stack (Loki) not deployed yet
- ❌ Need to complete a few TODOs marked in the code

## 📁 Project Structure


├── infra/ # Terraform: VPC, EKS, ECR, IAM, etc.

│ └── modules/ # Terraform modules (vpc, eks, iam, ecr, etc.)

├── charts/hwn # Helm chart for the Node.js app

├── .github/workflows/ # CI/CD pipelines

├── hello-world-node/ # Application

└── README.md # You are here


## 🚀 How to Deploy

1. Provision Infrastructure with Terraform
   Creates VPC, subnets, EKS cluster, IAM roles, and more.

cd ./infra/terraform 

terraform init 

terraform apply 

2. ArgoCD is still in progress. Helm chart is working and ready. Use manual installation.
   
cd ./charts/hwn

helm install hwn ./charts/hwn -n hwn --wait --timeout 5m 

3. Build & Push Docker Image
Triggered automatically by a GitHub Action on push to main brainch of ./hello-world-node

Docker image is built and pushed to Amazon ECR



📝 Notes

- Most values are templated and configurable
- Labels follow Kubernetes recommended conventions
- Code written using Terraform best practices (separation of modules, outputs, etc.)

Once ArgoCD is configured, it will:
- Watch the Helm chart in the repo (charts/hello-world-node)
- Automatically sync updates to the cluster
