# Konfiguracja dla Azure ARM Builder
source "azure-arm" "debian" {
  # Authentication
  use_azure_cli_auth = true

  # Azure Infrastructure
  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  location            = var.location

  # Image Naming
  capture_name_prefix = var.vm_prefix
  managed_image_name  = "${var.vm_prefix}-base-image"

  # Temporary Resources
  temp_resource_group_name = join("_", [var.resource_group_name, "packer", "temp", "packer"])
  temp_compute_name        = join("-", [var.vm_prefix, "packer", "temp", "vm"])
  temp_nic_name            = join("-", [var.vm_prefix, "packer", "temp", "nic"])
  temp_os_disk_name        = join("-", [var.vm_prefix, "packer", "temp", "osdisk"])

  # Network Configuration
  virtual_network_name                   = "azpkbc-vnet"
  virtual_network_subnet_name            = "subnet-c"
  virtual_network_resource_group_name    = var.resource_group_name
  private_virtual_network_with_public_ip = true

  # Storage and Gallery Settings
  managed_image_zone_resilient       = true
  managed_image_storage_account_type = "Standard_LRS"
  disk_additional_size               = var.disk_additional_size

  # Shared Image Gallery Destination
  shared_image_gallery_destination {
    subscription   = var.subscription_id
    resource_group = var.resource_group_name
    gallery_name   = "shared_image_gallery"
    image_name     = var.image_name
    image_version  = var.image_version
  }

  # Base Image Parameters
  os_type         = var.base_image_params.os_type
  image_publisher = var.base_image_params.image_publisher
  image_offer     = var.base_image_params.image_offer
  image_sku       = var.base_image_params.image_sku
  image_version   = var.base_image_params.image_version

  # VM Configuration
  vm_size         = var.vm_size
  os_disk_size_gb = var.os_disk_size_gb

  # Cloud-init for SSH key injection
  # user_data = templatefile("scripts/cloud-init.yaml.tpl", { ssh_public_key = local.ssh_public_key })


  # Polling and Timeout
  polling_duration_timeout = "30m"

  # Azure Tags
  azure_tags = {
    environment = "dev"
    project     = "azpkbc-lab08b-base-img"
    lab         = "08b"
    group       = "14Kx"
    subgroup    = "K0x"
    owner       = "Xavras Wyżryn"
  }
}
