targetScope = 'subscription' // subscription scope required to create resource group

// All params are set by pipeline variables through token replacement
// Prefix with spaceGame to ensure params are unique to module params
param spaceGameRegion string = '__region__'
param spaceGameResourceGroupName string = '__appresourcegroup__'
param spaceGameDbResourceGroupName string = '__dbresourcegroup__'
param spaceGameServicePlanName string = '__appserviceplan__-__system.stagename__'
param spaceGameAppServiceName string = '__appservicename__' 
param spaceGameSqlServerName string = '__sqlServerName__'
param spaceGameStorageAccountName string = '__storageAccountName__'
param spaceGameDbName string = '__dbName__'
param spaceGameDbUserName string = '__adminLogin__'

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: spaceGameResourceGroupName
  location: spaceGameRegion
}
 
// Create SQL
module sql './sql.bicep' = {
  name: 'sql'
  scope: resourceGroup('${spaceGameDbResourceGroupName}')
  params:{
    sqlServerName: spaceGameSqlServerName 
    storageAccountName: spaceGameStorageAccountName
    dbName: spaceGameDbName
  }
}

// Create web app
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: resourceGroup('${spaceGameResourceGroupName}')
  params:{
    region: spaceGameRegion
    servicePlanName: spaceGameServicePlanName
    appServiceName: spaceGameAppServiceName 
    sqlServerName: spaceGameSqlServerName
    dbName: spaceGameDbName
    dbUserName: spaceGameDbUserName
    dbPassword: '__adminPassword__'
  }
}