targetScope = 'subscription' // subscription scope required to create resource group

// All params are set by pipeline variables through token replacement
param region string = '__region__'
param resourceGroupName string = '__appresourcegroup__'
param dbResourceGroupName string = '__dbresourcegroup__'
param servicePlanName string = '__appserviceplan__-__system.stagename__'
param appServiceName string = '__appservicename__' 
param sqlServerName string = '__sqlServerName__'
param storageAccountName string = '__storageAccountName__'
param dbName string = '__dbName__'
param dbUserName string = '__adminLogin__'
param dbPassword string = '__adminPassword__'

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: region
}
 
// Create SQL
module sql './sql.bicep' = {
  name: 'sql'
  scope: resourceGroup('${dbResourceGroupName}')
  params:{
    sqlServerName: sqlServerName 
    storageAccountName: storageAccountName
    dbName: dbName
  }
}

// Create web app
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: resourceGroup('${resourceGroupName}')
  params:{
    region: region
    servicePlanName: servicePlanName
    appServiceName: appServiceName 
    sqlServerName: sqlServerName
    dbName: dbName
    dbUserName: dbUserName
    dbPassword: dbPassword
  }
}