variable "subscription_id" {
}
variable "client_id" {
}
variable "client_secret" {
}
variable "tenant_id" {
}

# Use TF Cloud for Backend
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "MarcusFelling"

    workspaces {
      name = "DemoSpaceGame"
    }
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}

# Variables
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

variable "appservicePlanTier" {
  default = "Basic"
}

variable "appservicePlanSize" {
  default = "B1"
}

variable "appservicePlanCapacity" {
  default = 1
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.appResourceGroup
  location = var.region
}

# Create Service Plan
resource "azurerm_app_service_plan" "serviceplan" {
  name                = var.appServicePlanName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "App"
  sku {
    tier     = var.appservicePlanTier
    size     = var.appservicePlanSize
    capacity = var.appservicePlanCapacity
  }
}

# Create App Service
resource "azurerm_app_service" "appservice" {
  name                = var.appServiceName
  location            = azurerm_app_service_plan.serviceplan.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.serviceplan.id
}