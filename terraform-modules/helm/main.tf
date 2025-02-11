terraform {
  backend "s3" {}
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Path to your kubeconfig file
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.8"  # Specify the desired version of Argo CD
  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"  # Use "ClusterIP" for internal access
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.demo.com"  # Replace with your domain
  }

  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = "argocd.demo.com"  # Replace with your domain
  }

  set {
    name  = "server.ingress.tls[0].secretName"
    value = "argocd-tls"
  }
}