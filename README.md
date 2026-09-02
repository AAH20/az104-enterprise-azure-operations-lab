# AZ-104 Enterprise Azure Operations Lab

**Microsoft Azure · Azure Administrator · Microsoft Entra ID · Azure RBAC · Azure Policy · Azure Storage · Virtual Machines · Container Instances · Azure Virtual Network · Private Link · Azure Monitor · Log Analytics · Azure Backup · Bicep · Azure CLI**

[![CI](https://github.com/AAH20/az104-enterprise-azure-operations-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/AAH20/az104-enterprise-azure-operations-lab/actions/workflows/ci.yml) [![Bicep](https://img.shields.io/badge/IaC-Bicep-0078D4)](infra/main.bicep) [![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

An exam-aligned, budget-controlled Azure administration laboratory that turns AZ-104 objectives into infrastructure code, operational exercises and explicit evidence requirements. It is the implementation foundation for a future Azure Lighthouse MSP/MSSP control plane and Marketplace-delivered A2Z SOC appliance.

> **Status:** locally implemented and structurally tested. Cloud deployment evidence is not claimed until a successful Azure `what-if`, deployment and verification are recorded. Billable compute, Bastion and alert delivery default to disabled.

## AZ-104 coverage

| Current Microsoft domain | Weight | Repository evidence |
|---|---:|---|
| Manage identities and governance | 20–25% | RBAC lab, tag policy, assignment, budget, tags and resource group |
| Implement and manage storage | 15–20% | OAuth-only storage, Private Link, DNS, versioning and soft delete |
| Deploy and manage compute | 20–25% | Conditional Linux container plus VM/App Service comparison lab |
| Implement virtual networking | 15–20% | VNet, subnets, NSG, Private Endpoint and optional Bastion |
| Monitor and maintain resources | 10–15% | Log Analytics, action group, Recovery Services vault and recovery lab |

Source: [Microsoft’s AZ-104 study guide, skills measured from April 17, 2026](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104).

## Architecture

```text
subscription scope
├── resource group
├── custom Azure Policy + assignment
└── monthly cost budget

resource-group scope
├── VNet
│   ├── workload subnet + NSG
│   ├── private-endpoint subnet
│   └── AzureBastionSubnet
├── OAuth-only StorageV2
│   ├── private endpoint
│   ├── private DNS
│   ├── versioning
│   └── soft deletion
├── optional Linux container
├── Log Analytics workspace
├── Recovery Services vault
└── optional alert action group
```

## Validate

```bash
./scripts/validate.sh
```

## Preview safely

Deploy subscription governance first, then use `what-if`:

```bash
AZ104_LOCATION=eastus AZ104_RESOURCE_GROUP=rg-az104-enterprise-lab ./scripts/deploy-governance.sh
AZ104_RESOURCE_GROUP=rg-az104-enterprise-lab ./scripts/what-if.sh
```

Review every proposed change before deployment. Enabling compute, Bastion, monitoring ingestion or backup can incur cost.

## Lab sequence

1. [Identity and governance](docs/labs/01-identity-governance.md)
2. [Storage](docs/labs/02-storage.md)
3. [Compute](docs/labs/03-compute.md)
4. [Networking](docs/labs/04-networking.md)
5. [Monitoring, backup and recovery](docs/labs/05-monitor-backup.md)

## Evidence contract

For every exercise, retain:

- Requirement and architecture decision
- Template and parameters
- `what-if` result
- Deployment result
- Redacted portal screenshot
- Redacted CLI evidence
- Expected and injected failure
- Troubleshooting procedure
- Verification result
- Cost before and after
- Cleanup result

Evidence must be labeled `implemented`, `deployed`, `verified`, `simulated`, `planned` or `blocked`. A screenshot is supporting evidence, not proof by itself.

## Product roadmap

```text
AZ-104 operations lab
→ Azure Well-Architected decision engine
→ Azure Lighthouse MSP/MSSP control plane
→ A2Z SOC Linux virtual appliance
→ Marketplace Managed Application and Managed Service offers
→ A2A/MCP procurement and onboarding exchange
```

## Career positioning

This repository provides defensible evidence for Azure Administrator, Cloud Engineer, Infrastructure Engineer and junior-to-senior platform operations responsibilities. It does not claim certification before the examination is passed.

## Engage

[Request an Azure operations, MSP or MSSP assessment](https://a2zsoc.com/contact?topic=azure-managed-cloud-security&utm_source=github&utm_medium=repository).
