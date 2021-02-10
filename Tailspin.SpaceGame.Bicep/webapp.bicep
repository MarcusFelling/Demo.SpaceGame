// Web App params
param region string
param servicePlanName string
param appServiceName string 

// Connection string params
param sqlServerName string
param dbName string
param dbUserName string
param dbPassword string

var dbURI = environment().suffixes.sqlServerHostname

resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: servicePlanName
  location: region
  sku:{
    name: 'B1'
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: region
  properties: {
    serverFarmId: servicePlan.id
    siteConfig: {
      connectionStrings:[
        {
          type:'SQLAzure'
          connectionString: 'DefaultConnection=Server=tcp:${sqlServerName}${dbURI},1433;Initial Catalog=${dbName};Persist Security Info=False;User ID=${dbUserName};Password=${dbPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
        }
      ]
    }
  }
}
