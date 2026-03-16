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
