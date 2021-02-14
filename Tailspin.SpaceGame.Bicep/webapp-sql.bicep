// All resources
param region string

// SQL
param sqlServerName string
param storageAccountName string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: region
  properties: {
    administratorLogin: dbUserName
    administratorLoginPassword: dbPassword
    version: '12.0'
  }
  identity:{
    type:'UserAssigned'
    
  }
}

resource sqlServerADAdmin 'Microsoft.Sql/servers/administrators@2019-06-01-preview' = {
  name: '${sqlServerName}/ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: managedIdentity.name
    sid: managedIdentity.id
    tenantId: managedIdentity.properties.tenantId
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
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  } 
}

// Create passwordless connection string
resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${dbName};'
      type: 'SQLAzure'
    }
  }
}

resource appConfig 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${appService.name}/web'
  location: region
  properties: {
    netFrameworkVersion: 'v5.0'
  }
}

// Managed Identity
param managedIdentityName string
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' //Default as contributor role

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: region
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleDefinitionId, resourceGroup().id)

  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: managedIdentity.properties.principalId
  }
}
