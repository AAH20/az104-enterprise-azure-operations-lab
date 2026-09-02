targetScope = 'resourceGroup'

@description('Short lowercase identifier used in globally unique resource names.')
@minLength(3)
@maxLength(12)
param prefix string

param location string = resourceGroup().location
param environment string = 'lab'
param deployBillableCompute bool = false
param deployBastion bool = false
param deployAlerts bool = false
param alertEmail string = ''

var tags = {
  environment: environment
  workload: 'az104-enterprise-operations-lab'
  owner: 'a2zsoc'
  costControl: 'ephemeral'
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    prefix: prefix
    location: location
    tags: tags
    deployBastion: deployBastion
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    prefix: prefix
    location: location
    tags: tags
    privateEndpointSubnetId: network.outputs.privateEndpointSubnetId
    virtualNetworkId: network.outputs.virtualNetworkId
  }
}

module compute 'modules/compute.bicep' = {
  name: 'compute'
  params: {
    prefix: prefix
    location: location
    tags: tags
    subnetId: network.outputs.workloadSubnetId
    deployBillableCompute: deployBillableCompute
  }
}

module operations 'modules/operations.bicep' = {
  name: 'operations'
  params: {
    prefix: prefix
    location: location
    tags: tags
    deployAlerts: deployAlerts
    alertEmail: alertEmail
  }
}

output resourceIds object = {
  virtualNetwork: network.outputs.virtualNetworkId
  storageAccount: storage.outputs.storageAccountId
  logAnalyticsWorkspace: operations.outputs.workspaceId
  recoveryServicesVault: operations.outputs.recoveryServicesVaultId
  containerGroup: compute.outputs.containerGroupId
}
