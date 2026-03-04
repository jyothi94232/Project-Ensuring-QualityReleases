resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.workspace_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
