# IP pública estática para el Ingress, en el node resource group del AKS
resource "azurerm_public_ip" "ingress" {
  name                = "quadara-ingress-ip"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Credenciales de usuario para conectarse al cluster con Helm
data "azurerm_kubernetes_cluster_user_credentials" "aks" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_kubernetes_cluster.aks]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster_user_credentials.aks.kube_configs[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster_user_credentials.aks.kube_configs[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster_user_credentials.aks.kube_configs[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster_user_credentials.aks.kube_configs[0].cluster_ca_certificate)
  }
}

# Instalación de ingress-nginx vía Helm
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type           = "LoadBalancer"
          loadBalancerIP = azurerm_public_ip.ingress.ip_address
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/auth/healthz"
          }
        }
      }
    })
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_public_ip.ingress,
  ]
}
