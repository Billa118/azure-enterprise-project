# Day 09 – Terraform Modules

## Objective

Learn how to organize Terraform code using Modules to make infrastructure reusable, scalable, and easier to maintain.

---

## What are Terraform Modules?

A Terraform module is a collection of Terraform configuration files grouped together to perform a specific task.

Instead of keeping all resources inside a single `main.tf`, Terraform modules separate infrastructure into logical components such as:

- Networking
- Compute
- Security
- Storage

This makes the code easier to maintain and reusable across multiple environments.

---

## Project Structure

### Before Modules

```
terraform/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

### After Adding Modules

```
terraform/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
└── modules/
    ├── networking/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── compute/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── storage/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Storage Module

### variables.tf

```hcl
variable "storage_account_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
```

---

### main.tf

```hcl
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

### outputs.tf

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
```

---

## Calling the Module

The Storage module was called from the root `main.tf`.

```hcl
module "storage" {
  source = "./modules/storage"

  storage_account_name = "stmanoj20260720"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
```

---

## Terraform Commands Used

Format Terraform files

```bash
terraform fmt -recursive
```

Initialize Terraform

```bash
terraform init
```

Validate Configuration

```bash
terraform validate
```

Preview Infrastructure Changes

```bash
terraform plan
```

Deploy Infrastructure

```bash
terraform apply
```

View Managed Resources

```bash
terraform state list
```

---

## Terraform Plan

```
Plan: 1 to add, 0 to change, 0 to destroy.
```

Terraform detected only one new resource to create, ensuring no existing infrastructure would be modified.

---

## Deployment Result

```
Apply complete!

Resources: 1 added, 0 changed, 0 destroyed.
```

The Azure Storage Account was successfully deployed using the Terraform Storage Module.

---

## Verification

Verified that:

- Storage Account was created successfully.
- Terraform module executed without errors.
- Existing VM, VNet, NSGs, and other resources remained unchanged.
- Code was pushed successfully to GitHub.

---

## Git Commands

```bash
git add .
git commit -m "Day 9: Implement Terraform Storage Module"
git push
```

---

## Key Learning

- Understood Terraform Module architecture.
- Created a reusable Storage Module.
- Used variables inside a module.
- Used outputs inside a module.
- Called a module from the root configuration.
- Deployed Azure infrastructure using a custom module.
- Learned how modules improve code organization and reusability in enterprise Terraform projects.

---

## Project Status

Completed:

- Azure Resource Group
- Virtual Network
- Three Subnets
- Three Network Security Groups
- Public IP
- Network Interface
- Ubuntu Virtual Machine
- NGINX Installation
- Terraform Storage Module

---

## Next Topic

**Day 10 – Remote Terraform State**

Topics:

- Terraform State File
- Azure Storage Backend
- Storage Container
- Backend Configuration
- State Migration
- Benefits of Remote State in Team Environments