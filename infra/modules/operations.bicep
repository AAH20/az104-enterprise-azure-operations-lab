param prefix string
param location string
param tags object
param deployAlerts bool = false
param alertEmail string = ''

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${prefix}'
  location: location
  tags: tags
  properties: {
    retentionInDays: 30
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource vault 'Microsoft.RecoveryServices/vaults@2024-04-01' = {
  name: 'rsv-${prefix}'
  location: location
  tags: tags
  sku: { name: 'Standard' }
  properties: {
    publicNetworkAccess: 'Enabled'
    securitySettings: { softDeleteSettings: { softDeleteState: 'Enabled', softDeleteRetentionPeriodInDays: 14 } }
  }
}

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = if (deployAlerts) {
  name: 'ag-${prefix}'
  location: 'global'
  tags: tags
  properties: {
    groupShortName: take(prefix, 12)
    enabled: true
    emailReceivers: [
      { name: 'operator', emailAddress: alertEmail, useCommonAlertSchema: true }
    ]
  }
}

output workspaceId string = workspace.id
output recoveryServicesVaultId string = vault.id
output alertsDeployed bool = deployAlerts
