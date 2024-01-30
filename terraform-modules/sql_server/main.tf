resource "random_password" "sqlpwd" {
  length           = 32
  special          = true
  override_special = "_%@"
  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "random_password" "srvName" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_mssql_server" "mssql" {
  name                                 = "${var.prefix}${var.env_set}-azsql-${var.project}-${random_password.srvName.result}"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = azurerm_resource_group.rg.location
  version                              = "12.0"
  administrator_login                  = "${var.prefix}${var.env_set}-azsql-admin"
  administrator_login_password         = random_password.sqlpwd.result
  minimum_tls_version                  = "1.2"
  outbound_network_restriction_enabled = true
  azuread_administrator {
    login_username = var.active_directory_administrator_login_username
    object_id      = var.active_directory_administrator_object_id
    tenant_id      = var.active_directory_administrator_tenant_id
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


# resource "azurerm_key_vault_secret" "sqlsecret" {
#   name         = "she-sql-server-admin-password"
#   value        = random_password.sqlpwd.result
#   key_vault_id = azurerm_key_vault.kv.id

#   depends_on = [
#     azurerm_key_vault.kv
#   ]
# }

# resource "azurerm_mssql_firewall_rule" "au" {
#   name             = "AllowCitrixAu"
#   server_id        = azurerm_mssql_server.srv.id
#   start_ip_address = var.AUCitrixIP
#   end_ip_address   = var.AUCitrixIP
# }
# resource "azurerm_mssql_firewall_rule" "in" {
#   name             = "AllowCitrixIn"
#   server_id        = azurerm_mssql_server.srv.id
#   start_ip_address = var.INCitrixIP
#   end_ip_address   = var.INCitrixIP
# }
# resource "azurerm_mssql_firewall_rule" "nl" {
#   name             = "AllowCitrixNl"
#   server_id        = azurerm_mssql_server.srv.id
#   start_ip_address = var.NLCitrixIP
#   end_ip_address   = var.NLCitrixIP
# }
# resource "azurerm_mssql_firewall_rule" "us" {
#   name             = "AllowCitrixUs"
#   server_id        = azurerm_mssql_server.srv.id
#   start_ip_address = var.USCitrixIP
#   end_ip_address   = var.USCitrixIP
# }

# resource "azurerm_mssql_firewall_rule" "PowerBI_Source" {
#   name             = "PowerBI_Source"
#   server_id        = azurerm_mssql_server.srv.id
#   start_ip_address = var.PowerBI_Source
#   end_ip_address   = var.PowerBI_Source
# }

# # Additional SQL Server configurations can go here...

# resource "random_password" "kvName" {
#   length  = 4
#   special = false
#   lower   = true
#   upper   = false
# }

# resource "azurerm_key_vault" "kv" {
#   name                        = "${var.prefix}${var.env_set}-kv-${var.project}-${random_password.kvName.result}"
#   location                    = azurerm_resource_group.rg.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false
#   enable_rbac_authorization   = true
#   sku_name                    = "standard"
#   tags                        = var.tags

#   network_acls {
#     default_action = "Deny"
#     ip_rules       = [var.agentIP, var.agentIP2, var.AUCitrixIP, var.INCitrixIP, var.NLCitrixIP, var.USCitrixIP]
#     bypass         = "AzureServices"
#   }
# }
