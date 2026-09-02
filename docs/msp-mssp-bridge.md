# From exam lab to managed service

The resource modules are intended to become customer-side deployments in a later Azure Lighthouse control plane.

| Lab capability | Managed-service evolution |
|---|---|
| RBAC | delegated least-privilege Lighthouse roles and PIM |
| Policy | customer policy initiatives, remediation and compliance reporting |
| Storage | tenant-local immutable evidence and retention |
| Network | standardized landing zones, Private Link and connectivity diagnostics |
| Log Analytics | customer-local monitoring and Sentinel workspaces |
| Backup | policy compliance, restore testing and RTO/RPO reporting |
| Bicep | repeatable customer onboarding and Marketplace packaging |

No cross-tenant claims are made in this repository. Those controls belong in the later Lighthouse project and require a separate customer or test tenant for credible validation.
