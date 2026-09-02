#!/usr/bin/env bash
set -euo pipefail

: "${AZ104_LOCATION:=eastus}"
: "${AZ104_RESOURCE_GROUP:=rg-az104-enterprise-lab}"

az deployment group what-if \
  --resource-group "$AZ104_RESOURCE_GROUP" \
  --template-file infra/main.bicep \
  --parameters infra/lab.bicepparam \
  --no-pretty-print
