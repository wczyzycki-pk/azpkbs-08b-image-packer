# Shared Image Gallery for custom VM images
resource "azurerm_shared_image_gallery" "this" {
  name                = "shared_image_gallery"
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.rg.location
  description         = "Shared Image Gallery for Azure course labs"

  tags = var.default_tags
}

# Image definition in the gallery
resource "azurerm_shared_image" "image" {
  name                = var.image_name
  gallery_name        = azurerm_shared_image_gallery.this.name
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  # hyper_v_generation = "V2"

  identifier {
    publisher = "azpkbc"
    offer     = "debian12"
    sku       = "base"
  }

  tags = var.default_tags
}
