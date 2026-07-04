# Day 04 - Terraform Fundamentals

## Objective

Today I learned the basics of Terraform and created my first Azure Resource Group using Infrastructure as Code (IaC).

---

# What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp.

Instead of manually creating Azure resources using the Azure Portal, Terraform allows us to define infrastructure in code and deploy it automatically.

Example:

Azure Portal
→ Click Create Resource Group
→ Click Create Virtual Network
→ Click Create VM

Terraform

Write Code
↓

terraform apply
↓

Azure Infrastructure Created Automatically

---

# What is Infrastructure as Code (IaC)?

Infrastructure as Code is the practice of managing cloud infrastructure using configuration files instead of manually creating resources.

Benefits:
- Automation
- Version Control
- Repeatability
- Consistency
- Faster Deployments

---

# Terraform Project Structure

terraform/

├── versions.tf
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── .gitignore

Purpose of each file:

versions.tf
- Defines Terraform version
- Defines required providers

provider.tf
- Configures Azure Provider

main.tf
- Contains Azure resources

variables.tf
- Declares input variables

terraform.tfvars
- Stores values for variables

outputs.tf
- Displays output values after deployment

.gitignore
- Prevents unnecessary files from being committed to Git

---

# versions.tf

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

Purpose:
- Specifies Terraform version.
- Downloads Azure Provider.
- Locks provider version.

---

# provider.tf

```hcl
provider "azurerm" {
  features {}
}
```

Purpose:
- Connects Terraform to Azure.
- Uses Azure CLI authentication.
- features {} enables default Azure provider settings.

---

# main.tf

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-enterprise-dev-tf"
  location = "Central India"
}
```

Purpose:
- Creates an Azure Resource Group.

---

# Terraform Workflow

1. Write Terraform Code

↓

2. terraform init

Downloads Azure Provider

↓

3. terraform validate

Checks configuration syntax

↓

4. terraform plan

Shows execution plan

↓

5. terraform apply

Creates Azure resources

↓

6. terraform destroy

Deletes Azure resources

---

# Commands Learned

terraform init

Purpose:
Downloads required providers and initializes Terraform.

---

terraform validate

Purpose:
Checks Terraform syntax.

---

terraform plan

Purpose:
Shows what Terraform will create, update or delete.

No Azure resources are created.

---

terraform apply

Purpose:
Creates Azure resources.

---

terraform destroy

Purpose:
Deletes resources managed by Terraform.

---

# Files Created by Terraform

.terraform/

Stores downloaded providers.

terraform.tfstate

Stores current infrastructure state.

terraform.lock.hcl

Locks provider version for consistency.

---

# Git Ignore

Ignored files:

.terraform/
*.tfstate
*.tfstate.*
*.tfvars

Committed:

main.tf
provider.tf
versions.tf
variables.tf
outputs.tf
.gitignore
.terraform.lock.hcl

---

# Problems Faced

Problem:
GitHub rejected push because Terraform provider was over 100 MB.

Reason:
Accidentally committed .terraform folder.

Solution:
- Updated .gitignore
- Removed provider files from Git tracking
- Committed only Terraform source files

---

# Interview Questions

### What is Terraform?

Terraform is an Infrastructure as Code tool used to provision and manage cloud resources using configuration files.

---

### What is Infrastructure as Code?

Managing infrastructure using code instead of manual configuration.

---

### What is a Provider?

A Provider is a plugin that allows Terraform to communicate with cloud platforms like Azure, AWS or Google Cloud.

---

### What does terraform init do?

- Initializes the project
- Downloads providers
- Creates .terraform folder
- Creates .terraform.lock.hcl

---

### What does terraform validate do?

Checks Terraform configuration for syntax errors.

---

### What does terraform plan do?

Shows the execution plan without making any changes.

---

### What does terraform apply do?

Creates or updates Azure infrastructure.

---

### What is terraform.tfstate?

A state file that stores information about infrastructure managed by Terraform.

---

# Hands-on Completed

✅ Installed Terraform

✅ Verified Azure CLI

✅ Connected Terraform to Azure

✅ Created Terraform project structure

✅ Wrote versions.tf

✅ Wrote provider.tf

✅ Wrote main.tf

✅ Executed terraform init

✅ Executed terraform validate

✅ Executed terraform plan

✅ Executed terraform apply

✅ Created Azure Resource Group using Terraform

✅ Fixed GitHub large file issue

---

# Day 4 Summary

Today I learned the complete Terraform workflow and successfully deployed my first Azure Resource Group using Infrastructure as Code. I also learned how Terraform providers, state files, project structure, and Git best practices work in a real-world project.