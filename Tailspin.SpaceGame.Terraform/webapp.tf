terraform {
  required_version = ">= 0.11" 
    backend "azurerm" {
      storage_account_name = "__terraformstorageaccount__"
      container_name       = "terraform"
      key                  = "__system.stagename__.terraform.tfstate"
      access_key  ="__storagekey__"
    }
	}
  provider "azurerm" {
    version = "=2.0.0"
    features {}
}

variable "appResourceGroup" {
  default = "__appresourcegroup__"
}

variable "appServicePlanName" {
  default = "__appserviceplan__-__system.stagename__"
}

variable "appServiceName" {
  default = "__appservicename__"
}

variable "region" {
  default = "West US"
}

variable "appservicePlanSize" {
  default = "B1"
}
variable "appservicePlanCapacity" {
  default = 1
}

resource "azurerm_resource_group" "rg" {
  name     = local.appResourceGroup
  location = var.region
}

resource "azurerm_app_service_plan" "serviceplan" {
  name                = locals.appServicePlanName
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  kind                = "App"
  sku {
    size = var.appservicePlanSize
    capacity = var.appservicePlanCapacity
  }
}

resource "azurerm_app_service" "appservice" {
  name                = locals.appServiceName
  location            = "${azurerm_app_service_plan.serviceplan.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.serviceplan.id}"
}