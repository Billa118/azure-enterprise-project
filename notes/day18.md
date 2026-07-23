# Day 18 – Azure Bastion (Secure VM Access)

## Objective

The objective of Day 18 was to implement Azure Bastion to securely connect to an Azure Virtual Machine without exposing SSH (Port 22) to the public internet. Azure Bastion provides browser-based SSH/RDP access over HTTPS, improving security by eliminating direct public access to virtual machines.

---

# Architecture

```
                 Internet
                     │
                     ▼
               Azure Portal
                     │
                HTTPS (443)
                     │
              Azure Bastion
                     │
         AzureBastionSubnet
                     │
              Private Network
                     │
                     ▼
          vm-web-terraform (VM)
```

---

# Azure Resources Used

| Resource | Name |
|----------|------|
| Resource Group | rg-enterprise-dev |
| Virtual Network | Vnet01 |
| Virtual Machine | vm-web-terraform |
| Bastion Host | enterprise-bastion |
| Bastion Public IP | bastion-public-ip |
| Bastion Subnet | AzureBastionSubnet |

---

# Step 1 – Create Azure Bastion Subnet

Azure Bastion requires a dedicated subnet named **AzureBastionSubnet**.

Command:

```bash
az network vnet subnet create \
  --resource-group rg-enterprise-dev \
  --vnet-name Vnet01 \
  --name AzureBastionSubnet \
  --address-prefixes 10.0.4.0/26
```

Result:

- Successfully created AzureBastionSubnet.

---

# Step 2 – Create Bastion Public IP

Created a Standard Static Public IP for Azure Bastion.

Command:

```bash
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name bastion-public-ip \
  --sku Standard \
  --allocation-method Static
```

Result:

```
Provisioning State : Succeeded
Public IP          : 20.192.29.163
```

---

# Step 3 – Create Azure Bastion

Created the Bastion Host using the Virtual Network and Public IP.

Command:

```bash
az network bastion create \
  --resource-group rg-enterprise-dev \
  --name enterprise-bastion \
  --public-ip-address bastion-public-ip \
  --vnet-name Vnet01 \
  --location centralindia
```

Result:

- Azure Bastion deployed successfully.

---

# Step 4 – Verify Bastion

Verified the Bastion Host deployment.

Command:

```bash
az network bastion list \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

| Name | Provisioning State |
|------|--------------------|
| enterprise-bastion | Succeeded |

---

# Step 5 – Browser-based SSH Connection

Connected to the VM securely using Azure Bastion.

Navigation:

```
Azure Portal
    ↓
Virtual Machines
    ↓
vm-web-terraform
    ↓
Connect
    ↓
Bastion
```

Credentials Used:

```
Protocol : SSH
Username : azureuser
Authentication : VM Password
```

Result:

Successfully connected to the VM using a browser-based SSH session.

Terminal:

```
azureuser@vm-web-terraform:~$
```

---

# Why Azure Bastion?

Without Azure Bastion:

```
Internet
     │
 SSH (22)
     │
 VM Public IP
     │
     VM
```

Problems:

- Public SSH exposure
- Increased attack surface
- Brute-force attack risk

---

With Azure Bastion:

```
Internet
     │
HTTPS (443)
     │
Azure Portal
     │
Azure Bastion
     │
Private VNet
     │
VM
```

Benefits:

- No public SSH access required
- Secure browser-based SSH
- Reduced attack surface
- Enterprise-grade remote access

---

# Components Created

- AzureBastionSubnet
- Bastion Public IP
- Azure Bastion Host
- Browser-based SSH Connection

---

# Key Learning Outcomes

- Understood Azure Bastion architecture.
- Created the required AzureBastionSubnet.
- Deployed Azure Bastion successfully.
- Configured a dedicated Standard Public IP.
- Connected securely to the VM using browser-based SSH.
- Learned how Azure Bastion eliminates public SSH exposure.
- Understood enterprise best practices for secure VM administration.

---

# Screenshots Included

- Azure Bastion Overview
- AzureBastionSubnet
- Bastion Public IP
- Bastion Host Overview
- VM Connect → Bastion page
- Browser-based SSH session
- Resource Group showing Bastion resources

---

# Outcome

Successfully deployed Azure Bastion and securely connected to the backend virtual machine using browser-based SSH through the Azure Portal without directly exposing SSH to the internet. This demonstrated Microsoft's recommended approach for secure remote administration of Azure virtual machines.

---

# Commands Used

```bash
# Create Azure Bastion Subnet
az network vnet subnet create \
  --resource-group rg-enterprise-dev \
  --vnet-name Vnet01 \
  --name AzureBastionSubnet \
  --address-prefixes 10.0.4.0/26

# Create Bastion Public IP
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name bastion-public-ip \
  --sku Standard \
  --allocation-method Static

# Create Azure Bastion
az network bastion create \
  --resource-group rg-enterprise-dev \
  --name enterprise-bastion \
  --public-ip-address bastion-public-ip \
  --vnet-name Vnet01 \
  --location centralindia

# Verify Bastion
az network bastion list \
  --resource-group rg-enterprise-dev \
  -o table
```