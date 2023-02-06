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
  // extendedLocation: {
  //   name: 'string'
  //   type: 'CustomLocation'
  // }
  // identity: {
  //   type: 'string'
  //   userAssignedIdentities: {}
  // }
  properties: {
    configuration: {
      // activeRevisionsMode: 'string'
      // dapr: {
      //   appId: 'string'
      //   appPort: int
      //   appProtocol: 'string'
      //   enableApiLogging: bool
      //   enabled: bool
      //   httpMaxRequestSize: int
      //   httpReadBufferSize: int
      //   logLevel: 'string'
      // }
      ingress: {
        allowInsecure: false
        // customDomains: [
        //   {
        //     bindingType: 'string'
        //     certificateId: 'string'
        //     name: 'string'
        //   }
        // ]
        // exposedPort: int
        external: false
        // ipSecurityRestrictions: [
        //   {
        //     action: 'string'
        //     description: 'string'
        //     ipAddressRange: 'string'
        //     name: 'string'
        //   }
        // ]
        targetPort: 8080
        // traffic: [
        //   {
        //     label: 'string'
        //     latestRevision: bool
        //     revisionName: 'string'
        //     weight: int
        //   }
        // ]
        // transport: 'string'
      }
      // maxInactiveRevisions: 0
      // registries: [
      //   {
      //     identity: 'string'
      //     passwordSecretRef: 'string'
      //     server: 'string'
      //     username: 'string'
      //   }
      // ]
      // secrets: [
      //   {
      //     name: 'string'
      //     value: 'string'
      //   }
      // ]
    }
    // environmentId: 'string'
    managedEnvironmentId: containerAppEnvironmentId
    template: {
      containers: [
        {
          // args: [
          //   'string'
          // ]
          // command: [
          //   'string'
          // ]
          env: [
            {
              name: 'AZP_TOKEN'
              // secretRef: 'string'
              value: azpToken
            }
            {
              name: 'AZP_POOL'
              // secretRef: 'string'
              value: azpPool
            }
            {
              name: 'AZP_URL'
              // secretRef: 'string'
              value: azpUrl
            }
          ]
          image: containerImage
          name: 'azdevops-agent'
        //   probes: [
        //     {
        //       failureThreshold: int
        //       httpGet: {
        //         host: 'string'
        //         httpHeaders: [
        //           {
        //             name: 'string'
        //             value: 'string'
        //           }
        //         ]
        //         path: 'string'
        //         port: int
        //         scheme: 'string'
        //       }
        //       initialDelaySeconds: int
        //       periodSeconds: int
        //       successThreshold: int
        //       tcpSocket: {
        //         host: 'string'
        //         port: int
        //       }
        //       terminationGracePeriodSeconds: int
        //       timeoutSeconds: int
        //       type: 'string'
        //     }
        //   ]
        //   resources: {
        //     cpu: json('decimal-as-string')
        //     memory: 'string'
        //   }
        //   volumeMounts: [
        //     {
        //       mountPath: 'string'
        //       volumeName: 'string'
        //     }
        //   ]
        // }
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
              // auth: [
              //   {
              //     secretRef: 'string'
              //     triggerParameter: 'string'
              //   }
              // ]
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
      // volumes: [
      //   {
      //     name: 'string'
      //     storageName: 'string'
      //     storageType: 'string'
      //   }
      // ]
    }
    // workloadProfileType: 'string'
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
