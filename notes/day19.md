# Day 19 – Azure Monitor & Log Analytics

## Objective

Learn how to monitor Azure Virtual Machines using Azure Monitor, Azure Monitor Agent (AMA), Data Collection Rules (DCR), Azure Monitor Workspace, and Log Analytics Workspace.

---

# Architecture

```
                Azure Monitor
                      │
                      ▼
        Azure Monitor Agent (AMA)
                      │
                      ▼
        Data Collection Rule (DCR)
              /                 \
             ▼                   ▼
Azure Monitor Workspace    Log Analytics Workspace
```

---

# Resources Created

| Resource | Name |
|----------|------|
| Virtual Machine | vm-web-terraform |
| Azure Monitor Workspace | enterprise-amw |
| Log Analytics Workspace | enterprise-law |
| Data Collection Rule | vm-monitor-dcr |
| DCR Association | vm-association |

---

# Step 1 – Create Log Analytics Workspace

Created a Log Analytics Workspace to collect and store VM logs.

```bash
az monitor log-analytics workspace create \
  --resource-group rg-enterprise-dev \
  --workspace-name enterprise-law \
  --location centralindia
```

---

# Step 2 – Install Azure Monitor Agent

Installed Azure Monitor Agent (AMA) on the VM.

```bash
az vm extension set \
  --resource-group rg-enterprise-dev \
  --vm-name vm-web-terraform \
  --publisher Microsoft.Azure.Monitor \
  --name AzureMonitorLinuxAgent
```

Verification:

```bash
az vm extension list \
  --resource-group rg-enterprise-dev \
  --vm-name vm-web-terraform \
  -o table
```

---

# Step 3 – Register Microsoft.Monitor Provider

Azure Monitor Workspace creation required the Microsoft.Monitor resource provider.

Checked registration:

```bash
az provider show \
  --namespace Microsoft.Monitor \
  --query registrationState \
  -o tsv
```

Initially:

```
NotRegistered
```

Registered provider:

```bash
az provider register \
  --namespace Microsoft.Monitor
```

Verified:

```
Registered
```

---

# Step 4 – Create Azure Monitor Workspace

Created Azure Monitor Workspace.

```bash
az monitor account create \
  --name enterprise-amw \
  --resource-group rg-enterprise-dev \
  --location centralindia
```

Verification:

```bash
az monitor account list \
  --resource-group rg-enterprise-dev \
  -o table
```

---

# Step 5 – Create Data Collection Rule (DCR)

Created a Data Collection Rule to define how monitoring data is collected.

Example DCR JSON:

```json
{
  "properties": {
    "destinations": {
      "azureMonitorMetrics": {
        "name": "azureMonitorMetrics-default"
      }
    },
    "dataFlows": [
      {
        "streams": [
          "Microsoft-InsightsMetrics"
        ],
        "destinations": [
          "azureMonitorMetrics-default"
        ]
      }
    ]
  }
}
```

Create DCR:

```bash
az monitor data-collection rule create \
  --resource-group rg-enterprise-dev \
  --location centralindia \
  --name vm-monitor-dcr \
  --rule-file dcr.json
```

Verification:

```bash
az monitor data-collection rule list \
  --resource-group rg-enterprise-dev \
  -o table
```

Provisioning State:

```
Succeeded
```

---

# Step 6 – Associate DCR with VM

Get VM ID:

```bash
VM_ID=$(az vm show \
  --resource-group rg-enterprise-dev \
  --name vm-web-terraform \
  --query id -o tsv)
```

Get DCR ID:

```bash
DCR_ID=$(az monitor data-collection rule show \
  --resource-group rg-enterprise-dev \
  --name vm-monitor-dcr \
  --query id -o tsv)
```

Create association:

```bash
az monitor data-collection rule association create \
  --name vm-association \
  --resource "$VM_ID" \
  --rule-id "$DCR_ID"
```

Verify:

```bash
az monitor data-collection rule association list \
  --resource "$VM_ID" \
  -o table
```

Result:

```
vm-association
```

---

# Final Architecture

```
VM (vm-web-terraform)
        │
        ▼
Azure Monitor Agent
        │
        ▼
Data Collection Rule
      /           \
     ▼             ▼
Azure Monitor   Log Analytics
 Workspace        Workspace
```

---

# What I Learned

- Azure Monitor provides centralized monitoring for Azure resources.
- Azure Monitor Agent (AMA) collects logs and performance metrics from VMs.
- Log Analytics Workspace stores and enables querying of collected logs.
- Azure Monitor Workspace stores Azure Monitor metrics.
- Data Collection Rules (DCR) define what data is collected and where it is sent.
- DCR Associations connect a VM to a specific Data Collection Rule.

---

# Commands Used

```bash
az monitor log-analytics workspace create

az vm extension set

az provider register --namespace Microsoft.Monitor

az monitor account create

az monitor data-collection rule create

az monitor data-collection rule list

az monitor data-collection rule association create

az monitor data-collection rule association list
```

---

# Screenshots

- Azure Monitor Workspace
- Log Analytics Workspace
- Azure Monitor Agent Extension
- Data Collection Rule
- DCR Association
- Azure Portal Monitor Overview

---

# Outcome

Successfully configured Azure Monitor for an Azure Virtual Machine by:

- Creating Log Analytics Workspace
- Creating Azure Monitor Workspace
- Installing Azure Monitor Agent
- Creating Data Collection Rule
- Associating the DCR with the VM
- Verifying monitoring configuration

**Project Progress:** **19 / 30 Days Completed (63%)**