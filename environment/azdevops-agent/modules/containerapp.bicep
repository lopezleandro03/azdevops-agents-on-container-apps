// general Azure Container App settings
param location string
param name string
param containerAppEnvironmentId string

// Container Image ref
param containerImage string

// AzDevOps pool metadata
@secure()
param azpToken string
param azpUrl string
param azpPool string
param azpPoolId string

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'capp-${name}'
  location: location
  tags: {
    owner: 'Leandro'
    workload: 'AzureDevOps-Agents'
  }
  properties: {
    configuration: {
      ingress: {
        allowInsecure: false
        external: false
        targetPort: 8080
      }
      secrets: [
        {
          name: 'azptoken'
          value: azpToken
        }
      ]
    }
    managedEnvironmentId: containerAppEnvironmentId
    template: {
      containers: [
        {
          env: [
            {
              name: 'AZP_TOKEN'
              // Use secretRef to avoid disclosing the token from the containerApp configuration UI
              secretRef: 'azptoken'
            }
            {
              name: 'AZP_POOL'
              value: azpPool
            }
            {
              name: 'AZP_URL'
              value: azpUrl
            }
          ]
          image: containerImage
          name: 'azdevops-agent'
        }
      ]      
      revisionSuffix: 'azdevops-agent'
      scale: {
        maxReplicas: 10
        minReplicas: 2
        rules: [
          {
            name: 'jobsqueuelength'
            custom: {
              metadata: {
                organizationURLFromEnv: 'AZP_URL'
                personalAccessTokenFromEnv: 'AZP_TOKEN'
                poolID: azpPoolId
                poolName: azpPool
              }
              type: 'azure-pipelines'
            }
          }
        ]
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
