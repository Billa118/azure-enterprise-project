# Day 13 – Terraform Variables and Environment Configuration

## Objective

Learn how to manage different deployment environments using Terraform variable files while improving project maintainability and configuration management.

The goal was to separate environment-specific values from the Terraform code.

---

## Why Variable Files?

Instead of modifying Terraform code for every environment, different variable files can be used.

Example:

```
Terraform Code
        │
        ├── dev.tfvars
        ├── test.tfvars
        └── prod.tfvars
```

The same Terraform configuration can deploy multiple environments using different input values.

---

## Existing Variables

Project variables:

```hcl
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}
```

Variable validation was added to improve input verification.

---

## Default Variable File

Existing configuration:

```hcl
resource_group_name = "rg-enterprise-dev"
location            = "Central India"
```

File:

```
terraform.tfvars
```

---

## Development Environment

Created:

```
dev.tfvars
```

Contents:

```hcl
resource_group_name = "rg-enterprise-dev"
location            = "Central India"
```

---

## Testing Environment

Created:

```
test.tfvars
```

Contents:

```hcl
resource_group_name = "rg-enterprise-test"
location            = "East US"
```

---

## Production Environment

Created:

```
prod.tfvars
```

Contents:

```hcl
resource_group_name = "rg-enterprise-prod"
location            = "East US 2"
```

---

## Variable File Structure

```
terraform/

├── terraform.tfvars
├── dev.tfvars
├── test.tfvars
└── prod.tfvars
```

---

## Commands Used

List variable files

```bash
ls *.tfvars
```

Plan using development variables

```bash
terraform plan -var-file="dev.tfvars"
```

Validate configuration

```bash
terraform validate
```

---

## Validation Results

Terraform Plan

```
No changes. Your infrastructure matches the configuration.
```

Terraform Validate

```
Success! The configuration is valid.
```

---

## Benefits of tfvars Files

- Environment-specific configuration
- Reusable Terraform code
- Easier deployments
- Better project organization
- Simplified Dev, Test and Production management

---

## Enterprise Workflow

Development

```bash
terraform plan -var-file="dev.tfvars"
```

Testing

```bash
terraform plan -var-file="test.tfvars"
```

Production

```bash
terraform plan -var-file="prod.tfvars"
```

---

## Key Learning

- Learned how Terraform variable files work.
- Created separate environment configurations.
- Used `terraform plan` with custom variable files.
- Validated Terraform configuration.
- Understood how enterprise projects manage multiple environments.

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
- Storage Account
- Terraform Storage Module
- Remote Terraform Backend
- Terraform Workspaces
- Enterprise Module Structure
- Environment Variable Files

---

## Next Topic

# Day 14 – Azure Key Vault and Secure Secret Management

Topics:

- Azure Key Vault
- Secure Password Storage
- Terraform Sensitive Variables
- Secret Management
- Production Security Best Practices