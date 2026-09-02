#!/usr/bin/env bash
set -euo pipefail

: "${AZ104_LOCATION:=eastus}"
: "${AZ104_RESOURCE_GROUP:=rg-az104-enterprise-lab}"
: "${AZ104_BUDGET_USD:=25}"

az deployment sub create \
  --name az104-governance \
  --location "$AZ104_LOCATION" \
  --template-file infra/subscription/governance.bicep \
  --parameters location="$AZ104_LOCATION" resourceGroupName="$AZ104_RESOURCE_GROUP" monthlyBudgetUsd="$AZ104_BUDGET_USD"
