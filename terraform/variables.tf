variable "subscription_id" {
  type    = string
  default = ""
}

variable "resource_group_name" {
  type    = string
  default = "ParentalControl-RG"
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "aks_name" {
  type    = string
  default = "parental-control-aks"
}

variable "acr_name" {
  type    = string
  default = "quadaraacr"
}

variable "frontend_storage_name" {
  type    = string
  default = "quadarawebstorage"
}

variable "db_admin_user" {
  type    = string
  default = "pgadmin"
}

variable "db_admin_password" {
  type      = string
  sensitive = true
}

variable "pg_server_name" {
  type    = string
  default = "parental-control-db"
}

variable "keyvault_name" {
  type    = string
  default = "quadara-kv"
}
