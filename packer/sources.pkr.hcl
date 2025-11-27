# Konfiguracja dla Azure AMR Builder
source "azure-arm" "debian" {
  # Explicitly use Azure CLI authentication
  use_azure_cli_auth  = true
  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name

  # Shared Image Gallery configuration for versioning
  shared_image_gallery_destination {
    subscription   = var.subscription_id
    resource_group = var.resource_group_name
    gallery_name   = "shared_image_gallery"
    image_name     = var.image_name
    image_version  = var.image_version
  }

  location = var.location

  os_type         = var.base_image_params.os_type
  image_publisher = var.base_image_params.image_publisher
  image_offer     = var.base_image_params.image_offer
  image_sku       = var.base_image_params.image_sku
  image_version   = var.base_image_params.image_version

  vm_size         = var.vm_size
  os_disk_size_gb = var.os_disk_size_gb

  azure_tags = {
    environment = "dev"
    project     = "azpkbc-lab08b-base-img"
    lab         = "08b"
    group       = "14Kx"
    subgroup    = "K0x"
    owner       = "Xavras Wyżryn"
  }
}
