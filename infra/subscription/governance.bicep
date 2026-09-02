targetScope = 'subscription'

param location string
param resourceGroupName string
param requiredTagName string = 'owner'
param monthlyBudgetUsd int = 25
param deployBudget bool = true
param budgetStartDate string = utcNow('yyyy-MM-01')

resource labResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: {
    owner: 'a2zsoc'
    environment: 'lab'
    costControl: 'ephemeral'
  }
}

resource requireTag 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'a2zsoc-require-tag'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Require an operational ownership tag'
    description: 'Denies resources that do not declare the configured ownership tag.'
    metadata: { category: 'Tags' }
    parameters: {
      tagName: {
        type: 'String'
        defaultValue: requiredTagName
        metadata: { displayName: 'Required tag name' }
      }
    }
    policyRule: {
      if: {
        field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
        exists: 'false'
      }
      then: { effect: 'deny' }
    }
  }
}

resource requireTagAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'a2zsoc-require-tag'
  location: location
  properties: {
    displayName: 'Require ownership tag'
    policyDefinitionId: requireTag.id
    enforcementMode: 'Default'
    parameters: {
      tagName: { value: requiredTagName }
    }
    nonComplianceMessages: [
      { message: 'Declare the required ownership tag before deployment.' }
    ]
  }
}

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = if (deployBudget) {
  name: 'budget-az104-lab'
  properties: {
    amount: monthlyBudgetUsd
    category: 'Cost'
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: budgetStartDate
      endDate: '2027-12-01'
    }
    notifications: {
      Forecast80: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 80
        thresholdType: 'Forecasted'
        contactEmails: []
        contactGroups: []
        contactRoles: ['Owner']
      }
      Actual100: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 100
        thresholdType: 'Actual'
        contactEmails: []
        contactGroups: []
        contactRoles: ['Owner']
      }
    }
  }
}

output resourceGroupId string = labResourceGroup.id
output policyAssignmentId string = requireTagAssignment.id
output budgetDeployed bool = deployBudget
