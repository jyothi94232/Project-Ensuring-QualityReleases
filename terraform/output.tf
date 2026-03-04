# Output values from Terraform modules

output "resource_group_name" {
  value       = "${module.resource_group.resource_group_name}"
  description = "The name of the resource group"
}

output "app_service_name" {
  value       = "${module.appservice.app_service_name}"
  description = "The name of the Azure App Service"
}

output "app_service_default_hostname" {
  value       = "${module.appservice.app_service_default_hostname}"
  description = "The default hostname of the Azure App Service"
}

output "public_ip_address" {
  value       = "${module.publicip.public_ip_address}"
  description = "The public IP address of the VM"
}

output "log_analytics_workspace_id" {
  value       = "${module.loganalytics.workspace_workspace_id}"
  description = "The workspace ID (customer ID) for Log Analytics"
}

output "log_analytics_shared_key" {
  value       = "${module.loganalytics.workspace_primary_shared_key}"
  description = "The primary shared key for Log Analytics"
  sensitive   = true
}
