# Day 6 - Azure Networking, NSGs, Virtual Machine & NGINX

## Objective

Learn how to build a secure Azure network by creating a Virtual Network (VNet), multiple subnets, Network Security Groups (NSGs), and deploying an Ubuntu Virtual Machine with NGINX.

---

# Lab Architecture

```
Internet
    │
    ▼
Public IP
    │
    ▼
WebNSG
    │
    ▼
WEBsubnet
    │
    ▼
vm-web-01
    │
    ▼
NGINX
```

---

# Resources Created

## Resource Group

```
rg-enterprise-dev
```

---

## Virtual Network

```
vnet
```

---

## Subnets

- WEBsubnet
- APPsubnet
- DBsubnet

Purpose:

- WEBsubnet hosts web servers.
- APPsubnet hosts application servers.
- DBsubnet hosts database servers.

---

## Network Security Groups

Created three NSGs:

- WebNSG
- AppNSG
- DbNSG

Associated each NSG with its respective subnet.

---

## Inbound Rules

### WebNSG

| Port | Purpose |
|------|----------|
|22|SSH|
|80|HTTP|
|443|HTTPS|

### AppNSG

| Port | Purpose |
|------|----------|
|22|SSH|

### DbNSG

| Port | Purpose |
|------|----------|
|22|SSH|

---

# Virtual Machine

Created:

```
vm-web-01
```

Configuration

- Ubuntu Server 24.04 LTS
- Region: Central India
- Username: azureuser
- Subnet: WEBsubnet
- Public IP Enabled

---

# Installing NGINX Using Cloud-init

Cloud-init script:

```bash
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
```

Benefits:

- Automatic installation
- No manual configuration
- Faster deployments
- Infrastructure automation

---

# Testing

SSH Login

```bash
ssh azureuser@<Public-IP>
```

Check NGINX

```bash
sudo systemctl status nginx
```

Open browser

```
http://<Public-IP>
```

Successfully displayed:

```
Welcome to nginx!
```

---

# Problems Faced

## Problem 1

SSH was not working.

Reason

Port 22 was not allowed in the NSG.

Solution

Created an inbound rule allowing SSH.

---

## Problem 2

NGINX page was not opening.

Reason

HTTP (Port 80) was blocked.

Solution

Added an inbound rule allowing HTTP.

---

## Problem 3

Virtual Machine was created in the wrong subnet.

Reason

Selected APPsubnet instead of WEBsubnet.

Solution

Deleted the VM and recreated it in WEBsubnet.

---

## Problem 4

Terraform failed while creating the Resource Group.

Error

```
Resource already exists
```

Reason

The Resource Group was created manually before Terraform.

Solution

Imported the existing Resource Group into the Terraform state.

```bash
terraform import azurerm_resource_group.rg \
/subscriptions/<subscription-id>/resourceGroups/rg-enterprise-dev
```

---

# Terraform Verification

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

Terraform state and Azure resources are synchronized.

---

# Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform import

az login
az account show

ssh azureuser@<Public-IP>

sudo systemctl status nginx
```

---

# Concepts Learned

- Azure Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Inbound Security Rules
- Ubuntu Virtual Machine
- Cloud-init
- SSH
- Public IP
- NGINX
- Terraform Import
- Terraform State
- Infrastructure as Code (IaC)

---

# Interview Questions

## What is a Resource Group?

A logical container that stores Azure resources.

---

## What is a Virtual Network?

A private network in Azure that enables secure communication between Azure resources.

---

## What is a Subnet?

A subnet divides a Virtual Network into smaller logical networks.

---

## What is an NSG?

A Network Security Group is a virtual firewall that controls inbound and outbound traffic using security rules.

---

## Why associate an NSG with a subnet?

Associating an NSG with a subnet applies the same security rules to every resource deployed in that subnet.

---

## What is Cloud-init?

Cloud-init is a Linux initialization service that automatically configures a VM during its first boot.

---

## Why use Terraform Import?

Terraform Import allows existing Azure resources to be managed by Terraform without recreating them.

---

# Day 6 Summary

Successfully completed:

- Azure Networking
- Virtual Network
- Three Subnets
- Three NSGs
- Ubuntu VM
- SSH Configuration
- NGINX Deployment
- NSG Configuration
- Terraform Import
- Terraform State Synchronization