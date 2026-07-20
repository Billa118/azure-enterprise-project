# Day 10 – Remote Terraform State

## Objective

Learn how to store the Terraform state file remotely using Azure Storage Account instead of keeping it on the local machine.

This is the standard approach used in enterprise environments for team collaboration and state management.

---

## What is Terraform State?

Terraform stores information about the infrastructure it creates inside a state file.

Default state file:

```
terraform.tfstate
```

The state file helps Terraform understand:

- Which resources have been created
- Current infrastructure configuration
- Resource dependencies
- Changes required during future deployments

---

## Why Local State is Not Recommended?

When the state file is stored locally:

- Only one developer has access to it.
- Team collaboration becomes difficult.
- State file can be lost if the local machine fails.
- Multiple users may overwrite each other's changes.

For enterprise projects, the state file should be stored remotely.

---

## Remote Backend Architecture

```
Terraform
    │
    ▼
Azure Storage Account
    │
    ▼
Blob Container (tfstate)
    │
    ▼
terraform.tfstate
```

---

## Existing Storage Account

Storage Account used:

```
stmanoj20260720
```

Resource Group:

```
rg-enterprise-dev
```

---

## Create Storage Container

Created a Blob Container named:

```
tfstate
```

Command used:

```bash
az storage container create \
  --name tfstate \
  --account-name stmanoj20260720 \
  --account-key "<Storage Account Key>"
```

Output:

```json
{
  "created": true
}
```

---

## Backend Configuration

Created a new file:

```
backend.tf
```

Contents:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-enterprise-dev"
    storage_account_name = "stmanoj20260720"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

---

## Initialize Backend

Executed:

```bash
terraform init
```

Terraform detected the new backend and migrated the local state file to Azure Storage.

Output:

```
Successfully configured the backend "azurerm"!

Terraform has been successfully initialized!
```

---

## Verification

Verified:

- Storage Account exists.
- Blob Container created successfully.
- Backend configured successfully.
- Local state migrated to Azure.
- Terraform initialized successfully using AzureRM backend.

---

## Benefits of Remote State

- Shared state across team members
- Centralized infrastructure management
- Better collaboration
- Prevents accidental state loss
- Enterprise standard practice
- Supports remote state locking (when configured)

---

## Project Architecture

```
Developer Laptop
       │
terraform plan/apply
       │
       ▼
Azure Storage Account
       │
       ▼
Blob Container (tfstate)
       │
       ▼
terraform.tfstate
```

---

## Files Added

```
backend.tf
```

---

## Commands Used

Initialize backend

```bash
terraform init
```

Verify infrastructure

```bash
terraform plan
```

Check backend configuration

```bash
terraform state list
```

---

## Key Learning

- Understood Terraform State File.
- Learned the difference between Local State and Remote State.
- Created an Azure Blob Container.
- Configured AzureRM Backend.
- Migrated Terraform State to Azure Storage.
- Learned how enterprise teams manage Terraform state.

---

## Project Status

Completed:

- Azure Resource Group
- Virtual Network
- Subnets
- Network Security Groups
- Public IP
- Ubuntu Virtual Machine
- NGINX Deployment
- Terraform Modules
- Azure Storage Account
- Remote Terraform State

---

## Next Topic

# Day 11 – Terraform Workspaces

Topics:

- What are Terraform Workspaces?
- Default Workspace
- Dev, Test and Production Workspaces
- Environment Isolation
- Managing Multiple Environments
- Enterprise Deployment Strategy