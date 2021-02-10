// Creates all infrastructure for Space Game
// All params are set by pipeline variables through token replacement
targetScope = 'subscription' // subscription scope required to create resource group

// Create resource group
resource spacegameRg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '__resourcegroup__'
  location: '__region__'
}
var rgScope = resourceGroup('__resourcegroup__') // use the scope of the newly-created resource group

// Create web app and sql
module spacegame './webapp-sql.bicep' = {
  name: 'spacegame'
  scope: rgScope
  params:{
    region: '__region__'
    servicePlanName: '__appserviceplan__-__system.stagename__'
    appServiceName: '__appservicename__'  
    dbUserName: '__adminLogin__'
    dbPassword: '__adminPassword__'    
    sqlServerName: '__sqlServerName__' 
    storageAccountName: '__storageAccountName__'
    dbName: '__storageAccountName__'
  }
}