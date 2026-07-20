# Day 7 - Managing Azure Networking with Terraform

## Objective

Learn how to manage existing Azure networking resources using Terraform by importing them into the Terraform state instead of recreating them.

---

# Lab Architecture

```
Azure Subscription
│
└── rg-enterprise-dev
    │
    ├── Vnet01
    │   ├── WEBsubnet
    │   ├── APPsubnet
    │   └── DBsubnet
    │
    ├── WebNSG
    ├── AppNSG
    └── DbNSG
```

---

# Objective of Day 7

Move manually created Azure networking resources under Terraform management.

Resources managed today:

- Resource Group
- Virtual Network
- Three Subnets
- Three Network Security Groups

---

# Virtual Network

Terraform Resource

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "Vnet01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}
```

---

# Import Existing Virtual Network

Command

```bash
terraform import azurerm_virtual_network.vnet \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/virtualNetworks/Vnet01
```

Purpose

Instead of creating a new Virtual Network, Terraform starts managing the existing Azure resource.

---

# Subnets

Created Terraform resources for

- WEBsubnet
- APPsubnet
- DBsubnet

Terraform Configuration

```hcl
resource "azurerm_subnet" "web" {
  name                 = "WEBsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "app" {
  name                 = "APPsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "db" {
  name                 = "DBsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  default_outbound_access_enabled = false
}
```

---

# Import Existing Subnets

WEBsubnet

```bash
terraform import azurerm_subnet.web \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/virtualNetworks/Vnet01/subnets/WEBsubnet
```

APPsubnet

```bash
terraform import azurerm_subnet.app \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/virtualNetworks/Vnet01/subnets/APPsubnet
```

DBsubnet

```bash
terraform import azurerm_subnet.db \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/virtualNetworks/Vnet01/subnets/DBsubnet
```

---

# Network Security Groups

Created Terraform resources for

- WebNSG
- AppNSG
- DbNSG

Terraform Configuration

```hcl
resource "azurerm_network_security_group" "web_nsg" {
  name                = "WebNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "AppNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "DbNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
```

---

# Import Existing NSGs

WebNSG

```bash
terraform import azurerm_network_security_group.web_nsg \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/networkSecurityGroups/WebNSG
```

AppNSG

```bash
terraform import azurerm_network_security_group.app_nsg \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/networkSecurityGroups/AppNSG
```

DbNSG

```bash
terraform import azurerm_network_security_group.db_nsg \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev/providers/Microsoft.Network/networkSecurityGroups/DbNSG
```

---

# Terraform Commands Used

Format

```bash
terraform fmt
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Import

```bash
terraform import
```

State Inspection

```bash
terraform state show
```

---

# Problems Faced

## Problem 1

Terraform attempted to create resources that already existed.

Reason

Resources were created manually in Azure Portal.

Solution

Imported the existing resources into Terraform.

---

## Problem 2

Terraform planned subnet updates.

Reason

Subnet address prefixes and provider defaults did not exactly match Azure.

Solution

Updated Terraform configuration to match Azure.

Added

```hcl
default_outbound_access_enabled = false
```

for all imported subnets.

---

# Final Verification

Command

```bash
terraform plan
```

Output

```
No changes.

Your infrastructure matches the configuration.
```

Meaning

Terraform state and Azure infrastructure are completely synchronized.

---

# Concepts Learned

- Infrastructure as Code
- Terraform Import
- Terraform State
- Azure Virtual Network
- Azure Subnets
- Azure Network Security Groups
- Terraform State Synchronization
- Resource Import
- Drift Detection

---

# Interview Questions

## What is Terraform Import?

Terraform Import allows existing cloud resources to be managed by Terraform without recreating them.

---

## Why use Terraform Import?

Many enterprise environments already have infrastructure deployed manually. Import enables Terraform to manage those resources.

---

## What is Terraform State?

Terraform State is a file that maps Terraform resources to real cloud resources.

---

## What happens if Terraform configuration does not match Azure?

Terraform detects the difference during `terraform plan` and proposes changes.

---

## Why should you always run `terraform plan` before `terraform apply`?

`terraform plan` previews all changes, helping prevent accidental modifications to production infrastructure.

---

# Day 7 Summary

Successfully completed:

- Imported Virtual Network
- Imported WEBsubnet
- Imported APPsubnet
- Imported DBsubnet
- Imported WebNSG
- Imported AppNSG
- Imported DbNSG
- Synchronized Terraform State
- Verified Infrastructure
- Terraform reported:

```
No changes.
Your infrastructure matches the configuration.
```

Day 7 marks the transition from manually managed Azure networking to Infrastructure as Code using Terraform.