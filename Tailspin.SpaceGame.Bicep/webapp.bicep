
param skuName string = 'B1'
param skuCapacity int = 1
param region string = 'West US'
param servicePlanName string = '__appserviceplan__-__system.stagename__'
param appServiceName string = '__appservicename__'

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