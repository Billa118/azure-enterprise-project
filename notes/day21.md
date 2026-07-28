# Day 21 – Azure Site Recovery & Disaster Recovery

## Objective

Implement disaster recovery for an Azure virtual machine using Azure Site Recovery (ASR).

The source VM was replicated from **Central India** to **South India**, followed by a test failover and cleanup of the DR infrastructure.

---

## Architecture

Source Region:
- Central India
- VM: `vm-web-terraform`
- Resource Group: `rg-enterprise-dev`
- Source VNet: `Vnet01`

Disaster Recovery Region:
- South India
- DR Resource Group: `rg-enterprise-dr`
- DR VNet: `Vnet-DR`
- DR Subnet: `DRSubnet`

Recovery Services Vault:
- `enterprise-asr-rsv`
- Region: South India

Replication:
Central India VM → Azure Site Recovery → South India

---

## 1. Check VM Replication Eligibility

Before enabling replication, checked whether the VM supported Azure Site Recovery.

```bash
az site-recovery replication-eligibility show-default \
  --resource-group rg-enterprise-dev \
  --virtual-machine-name vm-web-terraform \
  -o json