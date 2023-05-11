# main.tf

# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "my-aks-resource-group"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "my-aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "my-aks-dns"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
  }


  service_principal {
    client_id     = "740dfa8e-9f1b-4a66-9851-a307fe754482"
    client_secret = "YU~8Q~6_MMvmI67QfoJaKLyx3nps8RgsZw3KBbNu"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}


