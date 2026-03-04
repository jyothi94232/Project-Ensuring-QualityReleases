output "app_service_name" {
  value = "${azurerm_app_service.test.name}"
}

output "app_service_id" {
  value = "${azurerm_app_service.test.id}"
}

output "app_service_default_hostname" {
  value = "${azurerm_app_service.test.default_site_hostname}"
}
