// All resources
param region string

// SQL
param sqlServerName string
param dbName string
param dbUserName string
param dbPassword string 
param storageAccountName string

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: region
  properties: {
    administratorLogin: dbUserName
    administratorLoginPassword: dbPassword
    version: '12.0'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: storageAccountName
  location: region
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource database 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${dbName}'
  location: region
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    storageAccountType: 'GRS'
    minCapacity: 1
  }
}

resource firewallAllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = {
  name: '${sqlServer.name}/AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Web App
param servicePlanName string
param appServiceName string 

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
    serverFarmId: '${servicePlan.id}'
    siteConfig: {
      connectionStrings:[
        {
          type:'SQLAzure'
          connectionString: 'DefaultConnection=Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${dbName};Persist Security Info=False;User ID=${dbUserName};Password=${dbPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
        }
      ]
    }
  }
}
