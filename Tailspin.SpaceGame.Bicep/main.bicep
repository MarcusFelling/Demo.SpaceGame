// Creates all infrastructure for Space Game 
// All params are set by pipeline variables through token replacement
targetScope = 'subscription' // subscription scope required to create resource group

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '__appresourcegroup__'
  location: '__region__'
}
 
// Create SQL
module sql './sql.bicep' = {
  name: 'sql'
  scope: resourceGroup('${'__dbresourcegroup__'}')
  params:{
    sqlServerName: '__sqlServerName__' 
    storageAccountName: '__storageAccountName__'
    dbName: '__storageAccountName__'
  }
}

// Create web app
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: resourceGroup('${'__appresourcegroup__'}')
  params:{
    region: '__region__'
    servicePlanName: '__appserviceplan__-__system.stagename__'
    appServiceName: '__appservicename__'  
    sqlServerName: '__sqlServerName__'
    dbName: '__storageAccountName__'
    dbUserName: '__adminLogin__'
    dbPassword: '__adminPassword__'
  }
}