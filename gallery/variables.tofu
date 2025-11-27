variable "resource_group_name" {
  description = "Nazwa istniejącej grupy zasobów dla laboratoriów związanych z VM"
  type        = string
  nullable    = false
  default     = "azpkbc-rg-advanced-labs"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "France Central"
}

variable "image_name" {
  description = "Name of the output image"
  type        = string
  default     = "azpkbc-lab08b-base-image"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "azpkbc-lab08b-image-packer"
}

variable "default_tags" {
  description = "Typowe tagi dla zasobów."
  type        = map(string)
  default = {
    environment = "dev"
    project     = "prc-lab"
    lab         = "08"
    group       = "14Kx"
    subgroup    = "K0x"
    owner       = "Xavras Wyżryn"
  }
}

variable "ARM_SA_TFSTATE_NAME" {
  description = "Nazwa Storage Account dla backendu stanu Terraform"
  type        = string
  nullable    = false
  # from ENV
}
