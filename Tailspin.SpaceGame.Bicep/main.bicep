targetScope = 'subscription' // subscription scope required to create resource
param region string = 'West US' // region for all resources

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '__appresourcegroup__'
  location: region
}

var rgScope = resourceGroup('rg') // use the scope of the newly-created resource group for modules below

// Create web app
module webapp './webapp.bicep' = {
  name: 'webapp'
  scope: rgScope
  params:{
    skuName: 'B1'
    skuCapacity: 1
    region: rg.location
    servicePlanName: '__appserviceplan__-__system.stagename__'
    appServiceName: '__appservicename__'    
  }
}
