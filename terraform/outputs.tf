output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "postgres_database_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}
output "ingress_public_ip" {
  value = azurerm_public_ip.ingress.ip_address
}
