// Web App
param servicePlanName string
param appServiceName string
param appServiceSku string
param sqlServer string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}
param devEnv string // Used in condition for deployment slots

resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: servicePlanName
  location: resourceGroup().location
  sku:{
    name: appServiceSku
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: resourceGroup().location
  properties: {
    serverFarmId: '${servicePlan.id}'
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlServer},1433;Initial Catalog=${dbName};User Id=${dbUserName}@${sqlServer};Password=${dbPassword};'
      type: 'SQLAzure'
    }
  }
}

resource appConfig 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${appService.name}/web'
  location: resourceGroup().location
  properties: {
    netFrameworkVersion: 'v5.0'
  }
}

// Deploy deployment slot if it's not a dev environment
resource deploySlot 'Microsoft.Web/sites/slots@2018-11-01' = if(devEnv == 'false') {
  name: '${appService.name}/swap'
  location: resourceGroup().location
  kind: 'app'
  properties: {
    enabled: true
    serverFarmId: '${servicePlan.id}'
  }
}

