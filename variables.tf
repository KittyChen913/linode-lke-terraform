variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "cluster_label" {
  description = "Label for the LKE cluster"
  type        = string
  default     = "lke-cluster"
}

variable "cluster_region" {
  description = "Region for the LKE cluster"
  type        = string
  default     = "us-central"
}

variable "node_pool_count" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 3
}

variable "node_pool_type" {
  description = "Linode node type"
  type        = string
  default     = "g6-standard-1"
}

# Kubernetes Deployment variables
variable "deployment_name" {
  description = "Name of the web server deployment"
  type        = string
  default     = "web-server"
}

variable "deployment_namespace" {
  description = "Kubernetes namespace for the deployment"
  type        = string
  default     = "default"
}

variable "deployment_replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}

variable "app_label" {
  description = "App label for the deployment"
  type        = string
  default     = "nginx"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "nginx:1.14.2"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}
