variable "resource_group_name" {
  type        = string
  description = "Resource group name for the image"
  default     = "azpkbc-rg-advanced-labs"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "France Central"
}

variable "gallery_name" {
  type        = string
  description = "Nazwa Shared Image Gallery"
  default     = "shared_image_gallery"
}

variable "image_name" {
  type        = string
  description = "Name of the output image"
  default     = "azpkbc-lab08b-base-image"
}

variable "image_version" {
  type        = string
  description = "Version of the image in Shared Image Gallery"
  default     = "1.0.0"
}

variable "vm_size" {
  type        = string
  description = "VM size for building"
  default     = "Standard_D2d_v4"
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB"
  default     = 30
  validation {
    condition     = var.os_disk_size_gb >= 30
    error_message = "OS disk size must be at least 30 GB."
  }
}

variable "data_disk_size_gb" {
  type        = number
  description = "Data disk size in GB"
  default     = 10
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key file"
  default     = "~/.ssh/id_ed25519_az.pub"
}

variable "base_image_params" {
  type = object({
    os_type         = string,
    image_publisher = string,
    image_offer     = string,
    image_sku       = string,
    image_version   = string
  })
  default = {
    os_type         = "Linux",
    image_publisher = "Debian",
    image_offer     = "debian-12",
    image_sku       = "12",
    image_version   = "latest"
  }
}


variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = env("ARM_SUBSCRIPTION_ID")
}

locals {
  ssh_public_key = fileexists(pathexpand(var.ssh_public_key_path)) ? file(pathexpand(var.ssh_public_key_path)) : ""
}
