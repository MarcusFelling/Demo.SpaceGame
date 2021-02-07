param sqlServerName string
param dbName string
param storageAccountName string

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: 'southcentralus'
  properties: {
    administratorLogin: 'azuresql'
    version: '12.0'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: storageAccountName
  location: 'centralus'
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
  location: 'southcentralus'
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