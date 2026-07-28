# Day 26 – Azure Monitor & Log Analytics

## Objective

Learn how to monitor Azure resources using Azure Monitor and Log Analytics. Understand how to collect performance metrics, view activity logs, and analyze monitoring data for virtual machines.

---

# Architecture

```text
                  Azure VM
                     │
                     ▼
          Azure Monitor Agent (AMA)
                     │
                     ▼
       Log Analytics Workspace
            (enterprise-law)
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
    Performance Metrics       Log Data
        │                         │
        └────────────┬────────────┘
                     ▼
               Azure Monitor
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
   Metrics      Activity Logs     Alerts
```

---

# What is Azure Monitor?

Azure Monitor is Microsoft's monitoring platform used to collect, analyze, and visualize telemetry from Azure resources.

It helps administrators monitor:

- Virtual Machines
- Storage Accounts
- Databases
- Networking
- Applications
- Kubernetes Clusters

Azure Monitor collects:

- Metrics
- Logs
- Activity Logs
- Diagnostic Data

---

# What is Log Analytics?

Log Analytics is a service that stores and analyzes log data collected from Azure resources.

It allows administrators to:

- Search logs
- Troubleshoot issues
- Monitor performance
- Generate reports
- Create alerts

Queries are written using **Kusto Query Language (KQL).**

---

# Resource Details

| Resource | Value |
|----------|-------|
| Resource Group | rg-enterprise-dev |
| Workspace Name | enterprise-law |
| Region | centralindia |

---

# Step 1 – Create Log Analytics Workspace

```bash
az monitor log-analytics workspace create \
  --resource-group rg-enterprise-dev \
  --workspace-name enterprise-law \
  --location centralindia
```

---

# Step 2 – Verify Workspace

```bash
az monitor log-analytics workspace show \
  --resource-group rg-enterprise-dev \
  --workspace-name enterprise-law \
  -o table
```

Example Output

```text
Location      Name
------------  ---------------
centralindia  enterprise-law
```

---

# Step 3 – Get Workspace ID

```bash
az monitor log-analytics workspace show \
  --resource-group rg-enterprise-dev \
  --workspace-name enterprise-law \
  --query customerId \
  -o tsv
```

The Workspace ID uniquely identifies the Log Analytics Workspace.

---

# Step 4 – Install Azure Monitor Agent

Install the Azure Monitor Agent on **vm-web-terraform**.

```bash
az vm extension set \
  --resource-group rg-enterprise-dev \
  --vm-name vm-web-terraform \
  --publisher Microsoft.Azure.Monitor \
  --name AzureMonitorLinuxAgent
```

Install on **vm-web-02**.

```bash
az vm extension set \
  --resource-group rg-enterprise-dev \
  --vm-name vm-web-02 \
  --publisher Microsoft.Azure.Monitor \
  --name AzureMonitorLinuxAgent
```

---

# Step 5 – Verify Installed Extensions

```bash
az vm extension list \
  --resource-group rg-enterprise-dev \
  --vm-name vm-web-terraform \
  -o table
```

The Azure Monitor Linux Agent should appear in the list.

---

# Step 6 – Monitor VM CPU Usage

```bash
az monitor metrics list \
  --resource $(az vm show \
      -g rg-enterprise-dev \
      -n vm-web-terraform \
      --query id \
      -o tsv) \
  --metric "Percentage CPU"
```

Observed Result

- Average CPU usage remained below **1%**
- Highest spike observed was around **6%**
- Indicates the VM is healthy and mostly idle

---

# Step 7 – View Available Metrics

```bash
az monitor metrics list-definitions \
  --resource $(az vm show \
      -g rg-enterprise-dev \
      -n vm-web-terraform \
      --query id \
      -o tsv)
```

Common metrics available include:

- Percentage CPU
- Network In
- Network Out
- Disk Read Bytes
- Disk Write Bytes
- Disk Operations
- Memory (supported resources)

---

# Step 8 – Azure Activity Log

View recent management events.

```bash
az monitor activity-log list \
  --max-events 10 \
  -o table
```

Observed Events

- Azure Monitor Agent installation
- Log Analytics Workspace creation
- Azure Key Vault operations
- VM extension updates

Activity Logs record management operations performed on Azure resources.

---

# Step 9 – Azure Portal Monitoring

Navigate to:

```text
Azure Portal
    ↓
Monitor
```

Explore:

- Metrics
- Activity Log
- Alerts
- Logs
- Insights
- Workbooks

---

# Step 10 – Log Analytics Queries

Open:

```text
Azure Portal
↓
Log Analytics Workspaces
↓
enterprise-law
↓
Logs
```

Sample KQL Query

```kusto
Heartbeat
| take 10
```

Count connected computers

```kusto
Heartbeat
| summarize Count = count() by Computer
```

List computers

```kusto
Heartbeat
| distinct Computer
```

If no data appears immediately, wait a few minutes for the Azure Monitor Agent to begin sending telemetry.

---

# Azure Monitor Components

| Component | Purpose |
|-----------|---------|
| Metrics | Performance counters such as CPU, Disk, Network |
| Logs | Detailed monitoring information |
| Activity Logs | Azure management operations |
| Alerts | Automatic notifications |
| Workbooks | Monitoring dashboards |
| Insights | Resource-specific monitoring |

---

# Difference Between Metrics and Logs

| Metrics | Logs |
|----------|------|
| Numerical values | Detailed records |
| Near real-time | Historical analysis |
| Lightweight | Rich diagnostic data |
| Used for dashboards | Used for troubleshooting |

---

# Real-World Use Cases

- Monitor VM CPU utilization
- Detect storage performance issues
- Analyze application logs
- Troubleshoot outages
- Monitor network traffic
- Create alerts for high resource usage
- Capacity planning

---

# Best Practices

- Enable Azure Monitor on production resources.
- Install Azure Monitor Agent on all VMs.
- Store logs in Log Analytics Workspace.
- Create alerts for critical metrics.
- Regularly review Activity Logs.
- Build dashboards using Workbooks.

---

# Key Learnings

- Created a Log Analytics Workspace.
- Installed Azure Monitor Agent on Linux VMs.
- Monitored VM CPU utilization.
- Viewed Azure Activity Logs.
- Explored Azure Monitor services.
- Learned the basics of Kusto Query Language (KQL).
- Understood the difference between metrics and logs.

---

# Result

✅ Successfully configured Azure Monitor.

✅ Created and verified a Log Analytics Workspace.

✅ Installed Azure Monitor Agent on both virtual machines.

✅ Verified CPU metrics collection.

✅ Viewed Azure Activity Logs.

✅ Learned enterprise monitoring using Azure Monitor and Log Analytics.