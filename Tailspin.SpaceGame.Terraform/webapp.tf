 terraform {
  required_version = ">= 0.11" 
 backend "azurerm" {
  storage_account_name = "__terraformstorageaccount__"
    container_name       = "terraform"
    key                  = "__system.stagename__.terraform.tfstate"
	access_key  ="__storagekey__"
  features{}
	}
	}
  provider "azurerm" {
    version = "=2.0.0"
features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "__appresourcegroup__"
  location = "West US"
}

resource "azurerm_app_service_plan" "serviceplan" {
  name                = "__appserviceplan__-__system.stagename__"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  kind                = "App"

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "appservice" {
  name                = "__appservicename__"
  location            = "${azurerm_app_service_plan.serviceplan.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.serviceplan.id}"

}
