# Create K8s cluster

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-terraform-resource-group.name
  dns_prefix          = var.dns_prefix

  agent_pool_profile {
    name            = "default"
    count           = var.agent_count
    vm_size         = "Standard_B2s"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "K8s test"
  }
}

