terraform {
  backend "azurerm" {
    resource_group_name  = "rg-enterprise-dev"
    storage_account_name = "stmanoj20260720"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}