resource "kubernetes_deployment" "web_server" {
  metadata {
    name      = var.deployment_name
    namespace = var.deployment_namespace

    labels = {
      app = var.app_label
    }
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_label
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.app_label

          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [linode_lke_cluster.main]
}

resource "kubernetes_service" "web_server" {
  metadata {
    name      = "${var.deployment_name}-service"
    namespace = var.deployment_namespace

    labels = {
      app = var.app_label
    }
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      port        = 80
      target_port = var.container_port
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.web_server]
}

output "deployment_name" {
  description = "The name of the deployment"
  value       = kubernetes_deployment.web_server.metadata[0].name
}

output "service_name" {
  description = "The name of the service"
  value       = kubernetes_service.web_server.metadata[0].name
}

output "service_endpoint" {
  description = "The external endpoint of the LoadBalancer service"
  value       = try(kubernetes_service.web_server.status[0].load_balancer[0].ingress[0].hostname, "Pending...")
}
