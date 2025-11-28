# Azure Infrastructure
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = env("ARM_SUBSCRIPTION_ID")
}

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

# Gallery Configuration
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

# VM Configuration
variable "vm_prefix" {
  type        = string
  description = "Prefix for VM names"
  default     = "azpkbc"
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

variable "disk_additional_size" {
  type        = list(number)
  description = "Data disk sizes in GB"
  default     = []
}

# Base Image Parameters
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

# SSH Configuration
variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key file"
  default     = "~/.ssh/id_ed25519_az.pub"
}

# End of Life Configuration
variable "image_end_of_life_months" {
  type        = number
  description = "Number of months until image end of life"
  default     = 6
}

# Recommended VM Specifications
variable "image_recommended_specs" {
  type = object({
    cpu = object({
      min = number
      max = number
    })
    mem = object({
      min = number
      max = number
    })
  })
  description = "Recommended VM specifications for CPU (vCPUs) and memory (GB)"
  default = {
    cpu = {
      min = 1
      max = 4
    }
    mem = {
      min = 1
      max = 8
    }
  }
}

locals {
  ssh_public_key = (
    fileexists(pathexpand(var.ssh_public_key_path))
    ? file(pathexpand(var.ssh_public_key_path))
    : ""
  )
}
