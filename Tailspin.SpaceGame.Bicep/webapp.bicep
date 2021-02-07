param skuName string
param skuCapacity int
param region string
param servicePlanName string
param appServiceName string

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
