provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "aks" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.0.0/24"]
}

data "external" "aks_ssh_public_key" {
  program = ["bash", "-c", "az aks show --resource-group ${azurerm_resource_group.aks.name} --name ${var.cluster_name} --query 'linuxProfile.ssh.publicKeys[0].keyData' -o tsv"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = data.external.aks_ssh_public_key.result
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = var.node_count
    vm_size         = var.vm_size
    os_type         = "Linux"
    vnet_subnet_id  = azurerm_subnet.aks.id
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  depends_on = [azurerm_subnet.aks]
}

data "tls_private_key" "cluster_ssh" {
  algorithm = "RSA"
}

data "tls_public_key" "cluster_ssh" {
  private_key = data.tls_private_key.cluster_ssh.private_key_pem
}
