targetScope = 'subscription' // subscription scope required to create resource

// All params are set by pipeline variables through token replacement
param region string = '__region__'
param resourceGroupName string = '__appresourcegroup__'
param servicePlanName string = '__appserviceplan__-__system.stagename__'
param appServiceName string = '__appservicename__' 
param sqlServerName string = '__sqlServerName__'
param storageAccountName string = '__storageAccountName__'
param dbName string = '__dbName__'
param dbUserName string = '__adminLogin__'
param dbPassword string {
  secure: true
  default: '__adminPassword__'
}

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: region
}

// Create SQL
module sql './sql.bicep' = {
  name: 'sql'
  scope: resourceGroup('rg')
  params:{
    sqlServerName: sqlServerName 
    storageAccountName: storageAccountName
    dbName: dbName
  }
}

// Create web app
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: resourceGroup('rg')
  params:{
    skuName: 'B1'
    skuCapacity: 1
    region: rg.location
    servicePlanName: servicePlanName
    appServiceName: appServiceName 
    sqlServerName: sql.name
    dbName: dbName
    dbUserName: dbUserName
    dbPassword: dbPassword
  }
}