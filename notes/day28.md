# Day 28 – Azure Virtual Machine Scale Sets (VMSS)

## Objective

Deploy and manage an Azure Virtual Machine Scale Set (VMSS), perform manual scaling, understand Load Balancer integration, and troubleshoot real-world deployment issues.

---

## Azure Services Used

- Azure Virtual Machine Scale Sets (VMSS)
- Azure Load Balancer
- Azure Virtual Network (VNet)
- Public IP Address
- Azure Activity Log

---

## Resources Created

| Resource | Name |
|----------|------|
| Resource Group | rg-enterprise-dev |
| Virtual Machine Scale Set | enterpriseVmss |
| Load Balancer | enterprise-vmssLB |
| Backend Pool | enterprise-vmssLBBEPool |
| Virtual Network | vnet-eastus |
| Subnet | snet-eastus-1 |
| VM Image | Ubuntu Server 24.04 LTS |
| VM Size | Standard_DC1ds_v3 |
| Initial Instances | 2 |

---

## Implementation Steps

### Step 1 – Create VM Scale Set

Created a Virtual Machine Scale Set from the Azure Portal.

Configuration:

- Resource Group: rg-enterprise-dev
- Region: East US
- Image: Ubuntu Server 24.04 LTS
- VM Size: Standard_DC1ds_v3
- Orchestration Mode: Flexible
- Scaling Mode: Manual
- Initial Instances: 2

---

### Step 2 – Configure Networking

Configured:

- Virtual Network
- Subnet
- Azure Load Balancer
- Backend Pool
- Public IP Address

---

### Step 3 – Deploy VM Scale Set

Successfully deployed the VM Scale Set.

Azure created:

- 2 Virtual Machine instances
- Azure Load Balancer
- Backend Pool
- Networking resources

---

### Step 4 – Verify Deployment

Verified:

- VM Scale Set provisioning completed successfully.
- Two VM instances were created and running.

---

### Step 5 – Manual Scale-Out

Increased the instance count from:

```
2 → 3
```

Azure started provisioning a third VM instance.

---

## Issue Encountered

During the scale-out operation, the third VM failed to provision.

### Error

```
PublicIPCountLimitReached
```

### Error Message

```
Cannot create more than 3 public IP addresses for this subscription in this region.
```

---

## Root Cause

The Azure subscription reached the regional Public IP address limit.

The third VM instance required an additional Public IP address, which exceeded the subscription quota.

---

## Troubleshooting Performed

- Checked VMSS deployment status
- Reviewed VM Scale Set Activity Log
- Opened failed VM Activity Log
- Examined JSON error details
- Identified Public IP quota limitation
- Reviewed existing Public IP resources

---

## Verification

Verified that the VM Scale Set contains three VM instances.

```bash
az vmss list-instances \
  --resource-group rg-enterprise-dev \
  --name enterpriseVmss \
  -o table
```

Example output:

```
enterpriseVmss_79aa2810
enterpriseVmss_8edb497c
enterpriseVmss_ebb220a7
```

---

## Learning Outcomes

- Learned Azure Virtual Machine Scale Sets (VMSS)
- Understood Flexible Orchestration Mode
- Configured Azure Load Balancer with VMSS
- Performed manual scale-out
- Learned how Azure provisions additional VM instances
- Diagnosed provisioning failures using Activity Logs
- Understood Azure subscription quota limitations
- Learned the impact of Public IP quotas on VM Scale Set scaling

---

## Screenshots

- VMSS Creation Wizard
- VMSS Overview
- VMSS Instances
- Manual Scaling Configuration
- Failed Third Instance
- Activity Log Error
- Public IP Address List
- Final VMSS Instance List

---

## Conclusion

Successfully deployed an Azure Virtual Machine Scale Set with Azure Load Balancer and manually scaled the deployment. During scale-out, Azure returned a **PublicIPCountLimitReached** error because the subscription exceeded the allowed number of Public IP addresses in the region. The issue was investigated using Azure Activity Logs, demonstrating a real-world cloud troubleshooting scenario involving Azure resource quotas.