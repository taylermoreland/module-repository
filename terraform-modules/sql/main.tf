# sql_server/main.tf

resource "azurerm_resource_group" "sql_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_sql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = azurerm_resource_group.sql_rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

# Additional SQL Server configurations can go here...
