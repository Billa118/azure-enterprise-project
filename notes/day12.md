# Day 12 – Enterprise Terraform Module Structure

## Objective

Organize the Terraform project using an enterprise-standard module structure.

The goal of this session was to prepare the project for future scalability without modifying or recreating the existing Azure infrastructure.

---

## Why Terraform Modules?

As Terraform projects grow, keeping all resources inside a single `main.tf` file becomes difficult to maintain.

Terraform Modules help by:

- Organizing infrastructure into logical components
- Reusing infrastructure across projects
- Improving readability
- Simplifying maintenance
- Supporting team collaboration

Enterprise projects commonly separate infrastructure into modules.

---

## Existing Project

Current infrastructure already includes:

- Resource Group
- Virtual Network
- Subnets
- Network Security Groups
- Public IP
- Ubuntu Virtual Machine
- Storage Account
- Remote Terraform Backend

No existing resources were modified during Day 12.

---

## Enterprise Module Structure

Created the following module directories:

```
terraform/
│
├── backend.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── main.tf
│
└── modules/
    ├── compute/
    ├── networking/
    ├── security/
    └── storage/
```

---

## Networking Module

Created:

```
modules/networking/

├── main.tf
├── variables.tf
└── outputs.tf
```

Added input variables:

- resource_group_name
- location
- vnet_name
- address_space

Created output:

```hcl
output "module_name" {
  value = "networking"
}
```

---

## Compute Module

Created:

```
modules/compute/

├── main.tf
├── variables.tf
└── outputs.tf
```

Added input variables:

- resource_group_name
- location
- vm_name

Created output:

```hcl
output "module_name" {
  value = "compute"
}
```

---

## Security Module

Created:

```
modules/security/

├── main.tf
├── variables.tf
└── outputs.tf
```

Added input variables:

- resource_group_name
- location

Created output:

```hcl
output "module_name" {
  value = "security"
}
```

---

## Storage Module

The existing Storage module remains available:

```
modules/storage/

├── main.tf
├── variables.tf
└── outputs.tf
```

---

## Validation

Executed:

```bash
terraform validate
```

Output:

```
Success! The configuration is valid.
```

Validation confirmed that the Terraform configuration is syntactically correct after adding the new module structure.

---

## Important Note

The existing Azure infrastructure was **not moved** into the new modules.

Moving already deployed resources into Terraform modules requires state migration (`terraform state mv`) or Terraform `moved` blocks.

To avoid accidental recreation of infrastructure, only the module directory structure and placeholder files were created during this session.

---

## Enterprise Module Responsibilities

| Module | Purpose |
|---------|----------|
| networking | Virtual Network, Subnets, Route Tables |
| compute | Virtual Machines, NICs, Disks |
| security | Network Security Groups and Rules |
| storage | Storage Accounts and Containers |

---

## Commands Used

Create module directories

```bash
mkdir -p modules/networking
mkdir -p modules/compute
mkdir -p modules/security
```

Create Terraform files

```bash
touch modules/networking/main.tf
touch modules/networking/variables.tf
touch modules/networking/outputs.tf

touch modules/compute/main.tf
touch modules/compute/variables.tf
touch modules/compute/outputs.tf

touch modules/security/main.tf
touch modules/security/variables.tf
touch modules/security/outputs.tf
```

Validate configuration

```bash
terraform validate
```

---

## Key Learning

- Learned the purpose of Terraform Modules.
- Organized the project into an enterprise-ready structure.
- Created reusable module folders.
- Added standard Terraform files for each module.
- Added basic variables and outputs.
- Verified configuration using `terraform validate`.
- Understood why existing resources should not be moved without state migration.

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

---

## Next Topic

# Day 13 – Terraform Variables and Environment Configuration

Topics:

- terraform.tfvars
- Environment-specific tfvars
- Local Values (locals)
- Variable Validation
- Sensitive Variables
- Enterprise Configuration Management