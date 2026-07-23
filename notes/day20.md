# Day 20 - Azure Backup and Disaster Recovery

## Objective

Configure Azure Backup for an Azure Virtual Machine using a Recovery Services Vault and perform a restore operation.

---

## Resources Used

- Recovery Services Vault: enterprise-rsv
- Resource Group: rg-enterprise-dev
- Virtual Machine: vm-web-terraform
- Storage Account: stmanoj20260720

---

## Steps Performed

1. Created a Recovery Services Vault.
2. Configured Backup Storage Redundancy.
3. Enabled backup for the virtual machine.
4. Verified backup registration.
5. Created a recovery point.
6. Restored the VM disks from the recovery point.
7. Verified restore job completion.
8. Verified restored managed disk creation.

---

## Verification

- Backup Item: Healthy
- Recovery Point: Available
- Restore Job: Completed (100%)
- Restored Disk Successfully Created

---

## Commands Used

```bash
az backup vault create

az backup protection enable-for-vm

az backup recoverypoint list

az backup restore restore-disks

az backup job show

az disk list
```

---

## Learning Outcome

- Recovery Services Vault
- Azure VM Backup
- Recovery Points
- Disk Restore
- Disaster Recovery Concepts