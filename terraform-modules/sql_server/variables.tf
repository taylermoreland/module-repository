# sql_server/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The location for the SQL Server."
}

variable "sql_server_name" {
  description = "The name of the SQL Server."
}

variable "admin_username" {
  description = "The administrator username for the SQL Server."
}

variable "admin_password" {
  description = "The administrator password for the SQL Server."
}

# Additional variables specific to the SQL Server module can go here...
