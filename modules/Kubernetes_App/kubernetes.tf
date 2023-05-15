data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = var.org_name
    workspaces = {
      name = "eks-cluster"
    }
  }
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_namespace" "beacon" {
  metadata {
    name = var.application_name
  }
}

resource "kubernetes_deployment" "beacon" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.beacon.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = var.application_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }

      spec {
        container {
          image = "onlydole/beacon:datadog"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "beacon" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.beacon.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.beacon.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

output "web_endpoint" {
  value = "http://${kubernetes_service.beacon.status.0.load_balancer.0.ingress.0.hostname}:8080"
}
