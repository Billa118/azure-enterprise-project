# Day 24 – Azure Bastion

## Objective

Deploy Azure Bastion to securely access Azure Virtual Machines without exposing SSH (22) or RDP (3389) ports to the internet.

---

# Architecture

```
                Internet
                    │
                    ▼
             Azure Portal
                    │
                    ▼
            Azure Bastion Host
          (Public IP + HTTPS 443)
                    │
        AzureBastionSubnet (10.0.4.0/26)
                    │
             Virtual Network
                    │
         ┌──────────┴──────────┐
         ▼                     ▼
 vm-web-terraform         vm-web-02
     10.0.0.5              10.0.0.4
```

---

# Prerequisites

- Resource Group: `rg-enterprise-dev`
- Virtual Network: `Vnet01`
- AzureBastionSubnet
- Two Linux VMs
- Azure CLI installed

---

# Step 1 – Verify Bastion Subnet

```bash
az network vnet subnet list \
  --resource-group rg-enterprise-dev \
  --vnet-name Vnet01 \
  -o table
```

Output:

```
AzureBastionSubnet
10.0.4.0/26
Succeeded
```

---

# Step 2 – Check Public IPs

```bash
az network public-ip list \
  --resource-group rg-enterprise-dev \
  -o table
```

Initially:

- appgw-public-ip
- vm-web-pip
- vm-web-02-pip

Azure Free subscription reached the Standard Public IP quota.

---

# Step 3 – Remove an Unused Public IP

Detach the Public IP from the VM NIC:

```bash
az network nic ip-config update \
  --resource-group rg-enterprise-dev \
  --nic-name vm-web-02VMNic \
  --name ipconfigvm-web-02 \
  --remove publicIpAddress
```

Delete the unused Public IP resource:

```bash
az network public-ip delete \
  --resource-group rg-enterprise-dev \
  --name vm-web-02-pip
```

---

# Step 4 – Create Bastion Public IP

```bash
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name bastion-pip \
  --sku Standard \
  --allocation-method Static
```

---

# Step 5 – Deploy Azure Bastion

```bash
az network bastion create \
  --resource-group rg-enterprise-dev \
  --name enterprise-bastion \
  --public-ip-address bastion-pip \
  --vnet-name Vnet01 \
  --location centralindia
```

Deployment takes approximately 5–15 minutes.

---

# Step 6 – Verify Deployment

```bash
az network bastion show \
  --resource-group rg-enterprise-dev \
  --name enterprise-bastion \
  --query "{Provisioning:provisioningState}" \
  -o table
```

Output:

```
Provisioning
------------
Succeeded
```

---

# Step 7 – View Bastion Details

```bash
az network bastion list \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```
Name                : enterprise-bastion
Provisioning State  : Succeeded
Location            : centralindia
Scale Units         : 2
```

---

# Connect to a VM

1. Open Azure Portal.
2. Navigate to **Virtual Machines**.
3. Select **vm-web-terraform**.
4. Click **Connect** → **Bastion**.
5. Enter the VM username and password (or SSH key).
6. Click **Connect**.

A browser-based SSH session is established without exposing SSH to the internet.

---

# Why Azure Bastion?

| Traditional SSH | Azure Bastion |
|-----------------|---------------|
| Public IP required | No Public IP required |
| Port 22 exposed | No inbound SSH/RDP ports |
| Higher attack surface | Reduced attack surface |
| Requires SSH client | Browser-based access |
| Less secure | Enterprise-grade secure access |

---

# Advantages

- Secure browser-based access
- No inbound SSH/RDP ports
- Protects VMs from internet scanning
- Uses Azure-managed infrastructure
- Simplifies secure administration

---

# Real-World Use Cases

- Production Linux servers
- Windows RDP administration
- Banking and financial workloads
- Government cloud deployments
- Healthcare environments
- Enterprise landing zones

---

# Key Learnings

- Understood the purpose of Azure Bastion.
- Verified the AzureBastionSubnet configuration.
- Managed Public IP quota limitations.
- Created a dedicated Bastion Public IP.
- Deployed Azure Bastion.
- Verified successful provisioning.
- Learned how to securely access Azure VMs through the Azure Portal without exposing SSH or RDP.

---

# Result

✅ Azure Bastion deployed successfully.

✅ Secure VM administration enabled.

✅ Browser-based SSH available through Azure Portal.

✅ Eliminated the need for direct SSH exposure to the internet.