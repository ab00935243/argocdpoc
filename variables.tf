variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "client_secret" {
  description = "Azure AD Application Client Secret"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}


variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}

variable "vm_size" {
  description = "Size of the VMs in the AKS cluster"
  type        = string
}

variable "client_id" {
  description = "Client ID for the AKS cluster service principal"
}