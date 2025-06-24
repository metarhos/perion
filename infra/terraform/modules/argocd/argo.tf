# Work in progress. Module disabled

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# helm install argocd -n argocd -f values/argocd.yaml

resource "helm_release" "argocd" {

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = false
  version          = "3.35.4"
  # values = [file("${path.module}/argocd.yaml")]
  values = [
    templatefile("${path.module}/argocd.yaml", {
      namespace = kubernetes_namespace.argocd.metadata[0].name
    })
  ]

  force_update = true  # Force recreation if needed
  timeout      = 600   # Give more time for installation
  wait         = true  # Wait for resources to be ready

  depends_on = [kubernetes_namespace.argocd]
}

# 
# resource "kubernetes_ingress_v1" "argocd" {
#   metadata {
#     name      = "argocd-ingress"
#     namespace = kubernetes_namespace.argocd.metadata[0].name
#     annotations = {
#       "kubernetes.io/ingress.class" = "alb"
#       "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#     }
#   }

#   spec {
#     rule {
#       host = "argocd.${var.cluster_name}.example.com"
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = "argocd-server"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "aws_iam_role_policy" "argocd" {
#   name = "argocd-policy"
#   role = module.eks.eks_managed_node_groups.default.iam_role_name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#           "eks:DescribeCluster"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }