output "workspace_id" {
  value = "${azurerm_log_analytics_workspace.test.id}"
}

output "workspace_primary_shared_key" {
  value     = "${azurerm_log_analytics_workspace.test.primary_shared_key}"
  sensitive = true
}

output "workspace_workspace_id" {
  value = "${azurerm_log_analytics_workspace.test.workspace_id}"
}
