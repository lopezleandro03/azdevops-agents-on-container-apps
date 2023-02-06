param location string
param name string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'sb-infra'
        properties: {
          addressPrefix: '10.0.16.0/21'
        }
      }
      {
        name: 'sb-runtime'
        properties: {
          addressPrefix: '10.0.8.0/21'
        }
      }
    ]
  }
}

output vNetName string = virtualNetwork.name
output infrastructureSubnetId string = virtualNetwork.properties.subnets[0].name
output runtimeSubnetId string = virtualNetwork.properties.subnets[1].name
