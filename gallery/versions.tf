terraform {
  required_version = "~> 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54"
    }
  }
  # Remote backend configuration - do not touch this block
  backend "azurerm" {
    resource_group_name  = "azpkbc-rg-basic-labs"
    storage_account_name = var.ARM_SA_TFSTATE_NAME # everyone must update SA name to unique one
    container_name       = "tfstate"
    key                  = "${var.project}/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  # set your individual subscription id as env variable
  # in your ~/.bashrc or ~/.zshrc file like this:
  # export ARM_SUBSCRIPTION_ID=<your subscription id>
}
