// Creates all infrastructure for Space Game
// All params are set by pipeline variables through token replacement
targetScope = 'subscription' // switch to sub scope to create resource group

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '__resourceGroup__'
  location: deployment().location
}

// Create sql
module sql './sql.bicep' = {
  name: 'sql'
  scope: rg
  params:{
    sqlServerName: '__sqlServerName__'
    storageAccountName: '__storageAccountName__'
    dbName: '__dbName__'    
    dbUserName: '__adminLogin__'
    dbPassword: '__adminPassword__'         
  }
}

// Create web app 
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: rg
  params:{
    servicePlanName: '__appServicePlanName__'
    appServiceName: '__appServiceName__'
    appServiceSku: '__appServiceSku__'    
    sqlServer: sql.outputs.sqlServerFQDN // Use output from sql module to set connection string
    dbName: '__dbName__' // Used for connection string
    dbUserName: '__adminLogin__' // Used for connection string
    dbPassword: '__adminPassword__' // Used for connection string
    devEnv: true // Used for deployment slots, set in pipeline
    }
}      
