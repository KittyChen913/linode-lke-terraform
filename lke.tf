# 查詢 Linode 支持的 Kubernetes 版本
data "linode_lke_versions" "available" {
}

resource "linode_lke_cluster" "main" {
  label       = var.cluster_label
  k8s_version = data.linode_lke_versions.available.versions[length(data.linode_lke_versions.available.versions) - 1].id
  region      = var.cluster_region

  pool {
    type  = var.node_pool_type
    count = var.node_pool_count
  }

  tags = ["linode-lke", "terraform-managed"]
}

resource "local_file" "kubeconfig" {
  content  = base64decode(linode_lke_cluster.main.kubeconfig)
  filename = "${path.module}/kubeconfig.yaml"
}

output "cluster_id" {
  description = "The ID of the LKE cluster"
  value       = linode_lke_cluster.main.id
}

output "cluster_label" {
  description = "The label of the LKE cluster"
  value       = linode_lke_cluster.main.label
}

output "cluster_status" {
  description = "The status of the LKE cluster"
  value       = linode_lke_cluster.main.status
}

output "api_endpoints" {
  description = "The API endpoints of the LKE cluster"
  value       = linode_lke_cluster.main.api_endpoints
}

output "kubeconfig_file" {
  description = "The path to the kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "available_k8s_versions" {
  description = "List of available Kubernetes versions supported by Linode LKE"
  value       = data.linode_lke_versions.available.versions
}

output "selected_k8s_version" {
  description = "The Kubernetes version selected for this cluster"
  value       = linode_lke_cluster.main.k8s_version
}
