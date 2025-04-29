@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('Select the type of environment you want to provision. Allowed values are Production and Test.')
@allowed([
  'Production'
  'Test'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

// Define the names for resources.
var appServiceAppName = 'website-${resourceNameSuffix}'
var appServicePlanName = 'website'

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  Production: {
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 1
      }
    }
  }
  Test: {
    appServicePlan: {
      sku: {
        name: 'F1'
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppName string = appServiceApp.name
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
