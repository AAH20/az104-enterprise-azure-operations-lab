param prefix string
param location string
param tags object
param subnetId string
param deployBillableCompute bool = false

resource container 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = if (deployBillableCompute) {
  name: 'ci-${prefix}-proof'
  location: location
  tags: tags
  properties: {
    osType: 'Linux'
    restartPolicy: 'Never'
    subnetIds: [{ id: subnetId }]
    containers: [
      {
        name: 'health'
        properties: {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld:latest'
          resources: { requests: { cpu: 1, memoryInGB: 1 } }
          ports: [{ port: 80, protocol: 'TCP' }]
        }
      }
    ]
  }
}

output containerGroupId string = deployBillableCompute ? container.id : ''
