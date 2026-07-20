# Day 8 - Provision Azure Linux Virtual Machine Using Terraform

## Objective

Deploy an Azure Linux Virtual Machine using Terraform and automatically install NGINX during VM creation.

---

# Resources Created

- Public IP
- Network Interface (NIC)
- NIC to NSG Association
- Linux Virtual Machine
- NGINX Web Server

---

# Architecture

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
    ├── Public IP
    ├── Network Interface
    └── Linux Virtual Machine
         │
         └── NGINX
```

---

# Terraform Resources Used

- azurerm_public_ip
- azurerm_network_interface
- azurerm_network_interface_security_group_association
- azurerm_linux_virtual_machine

---

# VM Configuration

- OS : Ubuntu Server 24.04 LTS
- Region : Central India
- Admin Username : azureuser
- Authentication : Password
- OS Disk : Standard_LRS

---

# Cloud-init Script

```bash
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
```

Purpose:

- Updates packages
- Installs NGINX
- Starts the NGINX service
- Enables NGINX to start automatically after reboot

---

# Terraform Commands Used

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

# Verification

Verified that:

- VM created successfully
- Public IP assigned
- SSH login working
- NGINX installed automatically
- Browser displayed the default NGINX page

---

# Concepts Learned

## Infrastructure as Code (IaC)

Manage Azure resources using Terraform instead of creating them manually.

## Public IP

Provides internet access to the Virtual Machine.

## Network Interface (NIC)

Connects the Virtual Machine to the Virtual Network.

## Network Security Group (NSG)

Controls inbound and outbound traffic using security rules.

## Linux Virtual Machine

Ubuntu server deployed automatically using Terraform.

## Cloud-init

Runs commands automatically during the first boot of the VM.

## NGINX

A lightweight web server used to host websites and applications.

---

# Interview Questions

## What is Infrastructure as Code?

Infrastructure is created and managed using code instead of manual configuration.

---

## What is Cloud-init?

Cloud-init is a startup script that automatically configures a Linux VM during its first boot.

---

## Why use Terraform?

Terraform automates infrastructure deployment, ensures consistency, and supports version control.

---

## What is a Network Interface?

A Network Interface connects a Virtual Machine to a Virtual Network and enables network communication.

---

## Why is a Public IP required?

A Public IP allows users to access the Virtual Machine over the internet.

---

## What is NGINX?

NGINX is an open-source web server and reverse proxy used to serve web applications.

---

# Outcome

Successfully deployed an Azure Linux Virtual Machine using Terraform.

Terraform automatically created:

- Public IP
- Network Interface
- NSG Association
- Linux VM
- NGINX Web Server

Verified successful deployment by opening the NGINX welcome page in the browser.

---

# Day 8 Summary

Completed:

- Created Public IP
- Created Network Interface
- Associated NIC with NSG
- Created Linux Virtual Machine
- Installed NGINX using Cloud-init
- Verified deployment in browser
- Managed infrastructure using Terraform