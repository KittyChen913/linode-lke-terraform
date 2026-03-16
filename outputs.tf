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
