# Day 27 – Azure Alerts & Action Groups

## Objective

Learn how to create Azure Monitor Alerts and Action Groups to automatically notify administrators when infrastructure exceeds defined thresholds.

---

# Architecture

```text
                  Azure VM
                      │
               Performance Metrics
                      │
                      ▼
              Azure Monitor
                      │
                Alert Rule
                      │
             Condition Evaluated
                      │
             CPU > Threshold?
                      │
            ┌─────────┴─────────┐
            │                   │
           No                  Yes
            │                   │
            ▼                   ▼
      Continue Monitoring   Action Group
                                  │
            ┌─────────────────────┼─────────────────────┐
            ▼                     ▼                     ▼
         Email                  SMS                 Webhook
```

---

# What are Azure Monitor Alerts?

Azure Monitor Alerts continuously monitor Azure resources.

When a defined condition becomes true (for example, CPU usage exceeds a threshold), Azure automatically performs configured actions such as:

- Sending emails
- Sending SMS notifications
- Calling webhooks
- Triggering Azure Functions
- Triggering Logic Apps

Alerts help administrators detect problems before users are affected.

---

# What is an Action Group?

An Action Group defines what Azure should do after an alert is triggered.

Common notification methods:

- Email
- SMS
- Voice Call
- Push Notification
- Webhook
- Azure Function
- Logic App
- Event Hub

---

# Resources Used

| Resource | Value |
|----------|-------|
| Resource Group | rg-enterprise-dev |
| VM | vm-web-terraform |
| Action Group | enterprise-actiongroup |
| Alert Rule | HighCPUAlert |

---

# Step 1 – Create Action Group

```bash
az monitor action-group create \
  --resource-group rg-enterprise-dev \
  --name enterprise-actiongroup \
  --short-name entalert \
  --action email Admin billamanoj118@gmail.com
```

Verify:

```bash
az monitor action-group list \
  --resource-group rg-enterprise-dev \
  -o table
```

---

# Step 2 – Get VM Resource ID

```bash
VM_ID=$(az vm show \
  --resource-group rg-enterprise-dev \
  --name vm-web-terraform \
  --query id \
  -o tsv)

echo $VM_ID
```

---

# Step 3 – Create CPU Alert Rule

```bash
az monitor metrics alert create \
  --name HighCPUAlert \
  --resource-group rg-enterprise-dev \
  --scopes $VM_ID \
  --condition "avg Percentage CPU > 5" \
  --description "Alert when CPU exceeds 5%" \
  --window-size 5m \
  --evaluation-frequency 1m \
  --action enterprise-actiongroup
```

Verify:

```bash
az monitor metrics alert list \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```text
Description                Enabled   Severity
-------------------------  --------  --------
Alert when CPU exceeds 5%  True      2
```

---

# Step 4 – Generate CPU Load

SSH into the VM.

Generate CPU usage:

```bash
yes > /dev/null &
```

View CPU usage:

```bash
top
```

Stop the process:

```bash
pkill yes
```

> Note: Azure Monitor evaluates alerts periodically. If CPU usage does not remain above the threshold for the configured evaluation window, the alert may not fire.

---

# Step 5 – Verify Alert Rule

```bash
az monitor metrics alert show \
  --resource-group rg-enterprise-dev \
  --name HighCPUAlert \
  -o table
```

Result:

- Alert Rule Created
- Status: Enabled
- Severity: 2 (Warning)

---

# Step 6 – Azure Portal Verification

Navigate to:

```text
Azure Portal
    ↓
Monitor
    ↓
Alert Rules
```

Verified:

- HighCPUAlert
- Percentage CPU > 5
- Severity 2
- Target VM: vm-web-terraform

**Note:** The **Alert Rules** page lists configured rules. The **Alerts** page only displays alerts that have actually fired.

---

# Alert Evaluation Flow

```text
CPU Usage Generated
         │
         ▼
Azure Monitor Collects Metrics
         │
         ▼
Alert Rule Evaluates
         │
         ▼
Condition True?
         │
    ┌────┴────┐
    │         │
   No        Yes
    │         │
    ▼         ▼
Continue   Trigger Action Group
               │
      Email / SMS / Webhook
```

---

# Azure Alert Severity Levels

| Severity | Description |
|----------|-------------|
| Sev0 | Critical outage |
| Sev1 | High priority |
| Sev2 | Warning / Important issue |
| Sev3 | Minor issue |
| Sev4 | Informational |

---

# Common Enterprise Alert Rules

- CPU Utilization > 80%
- Memory Usage > 85%
- Disk Space < 10%
- VM Stopped
- VM Restarted
- Storage Capacity Threshold
- Database CPU Usage
- Application Response Time
- HTTP 500 Errors
- Network Latency

---

# Benefits of Azure Alerts

- Proactive monitoring
- Faster incident response
- Automated notifications
- Reduced downtime
- Improved operational visibility
- Better infrastructure reliability

---

# Best Practices

- Configure alerts only for important metrics.
- Avoid alert fatigue by using meaningful thresholds.
- Use Action Groups for centralized notifications.
- Periodically review and update alert rules.
- Combine Azure Monitor with Log Analytics for deeper diagnostics.

---

# Key Learnings

- Created an Azure Action Group.
- Configured a CPU-based metric alert.
- Linked the alert to an Action Group.
- Verified the alert configuration in Azure Portal.
- Understood how Azure Monitor evaluates alert conditions.
- Learned the difference between Alert Rules and Fired Alerts.

---

# Result

✅ Successfully created an Azure Action Group.

✅ Successfully configured a CPU Metric Alert.

✅ Verified the alert rule in Azure Portal.

✅ Learned enterprise monitoring and alerting using Azure Monitor.