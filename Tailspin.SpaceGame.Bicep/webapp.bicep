param skuName string
param skuCapacity int
param region string
param servicePlanName string
param appServiceName string

// Connection string params
param sqlServerName string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}
var dbURI = '[environment().suffixes.sqlServerHostname]'

resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: servicePlanName
  location: region
  sku:{
    name: skuName
    capacity: skuCapacity
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: region
  properties: {
    serverFarmId: servicePlan.id
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'DefaultConnection=Server=tcp:${sqlServerName}${dbURI},1433;Initial Catalog=${dbName};Persist Security Info=False;User ID=${dbUserName};Password=${dbPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
      type: 'SQLAzure'
    }
  }
}
