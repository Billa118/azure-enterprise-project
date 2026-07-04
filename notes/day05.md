# Day 05 - Terraform Variables, Outputs and State

## Objective

Today I learned how to make Terraform code reusable using variables, how to display useful information using outputs, and how Terraform keeps track of infrastructure using the state file.

---

# Why Variables?

Yesterday I hardcoded values inside main.tf.

Example:

```hcl
name = "rg-enterprise-dev-tf"
location = "Central India"
```

Hardcoding is not a good practice because every environment (Development, Testing, Production) would require editing the source code.

Instead, Terraform variables allow the same code to be reused by changing only the input values.

---

# Terraform Variable Flow

variables.tf

↓

Declares Variables

↓

terraform.tfvars

Stores Variable Values

↓

main.tf

Uses Variables

↓

Azure Resources Created

---

# variables.tf

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

Purpose:

- Declares Terraform variables
- Creates reusable inputs
- Defines data type

---

# terraform.tfvars

```hcl
resource_group_name = "rg-enterprise-dev-tf"
location            = "Central India"
```

Purpose:

- Stores values for variables
- Makes Terraform reusable
- Different environments can have different values

Example:

Development

resource_group_name = "rg-dev"

Testing

resource_group_name = "rg-test"

Production

resource_group_name = "rg-prod"

No changes are required in main.tf.

---

# Updated main.tf

Old Code

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-enterprise-dev-tf"
  location = "Central India"
}
```

New Code

```hcl
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
```

Purpose:

Terraform reads values from terraform.tfvars instead of hardcoded values.

---

# What does var. mean?

Example:

```hcl
var.resource_group_name
```

Meaning:

Get the value stored inside the variable named resource_group_name.

Example:

Variable

resource_group_name

↓

Value

rg-enterprise-dev-tf

↓

Terraform uses:

rg-enterprise-dev-tf

---

# Outputs

outputs.tf

```hcl
output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Azure Region"
  value       = azurerm_resource_group.rg.location
}

output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.rg.id
}
```

Purpose:

Displays useful information after Terraform creates infrastructure.

Example Output:

Resource Group Name

Azure Region

Resource Group ID

---

# Understanding Resource References

Example:

```hcl
azurerm_resource_group.rg.name
```

Meaning:

azurerm_resource_group

↓

Azure Resource Group Resource Type

rg

↓

Terraform Resource Name

name

↓

Resource Group Name Attribute

Similarly:

azurerm_resource_group.rg.location

Returns Azure Region

azurerm_resource_group.rg.id

Returns Azure Resource ID

---

# Terraform State

Terraform stores information about infrastructure in:

terraform.tfstate

Purpose:

- Tracks resources created by Terraform
- Detects changes
- Prevents duplicate resource creation
- Maintains infrastructure state

---

# Terraform State Commands

terraform show

Purpose:

Displays the current Terraform state.

---

terraform state list

Purpose:

Lists all resources managed by Terraform.

Example:

azurerm_resource_group.rg

---

terraform state show azurerm_resource_group.rg

Purpose:

Displays detailed information about the Resource Group managed by Terraform.

---

# Terraform Outputs After Apply

Example:

Outputs:

resource_group_name = "rg-enterprise-dev-tf"

resource_group_location = "centralindia"

resource_group_id = "/subscriptions/.../resourceGroups/rg-enterprise-dev-tf"

---

# Commands Learned

terraform validate

Checks Terraform configuration.

---

terraform plan

Shows execution plan before deployment.

---

terraform apply

Creates or updates infrastructure.

---

terraform show

Displays Terraform state.

---

terraform state list

Lists managed resources.

---

terraform state show <resource>

Displays details of a specific resource.

---

# Interview Questions

## What is a Terraform Variable?

A Terraform variable is an input that allows values to be passed into Terraform configurations without changing the source code.

---

## What is terraform.tfvars?

terraform.tfvars stores values for variables declared in variables.tf.

---

## What does var. mean?

var. is used to access the value of a Terraform variable.

Example:

var.resource_group_name

---

## What are Terraform Outputs?

Outputs display useful values after Terraform creates or updates infrastructure.

Examples:

- Resource IDs
- Resource Names
- Public IP Addresses
- URLs

---

## What is terraform.tfstate?

terraform.tfstate is a state file that stores information about infrastructure managed by Terraform.

---

## What does terraform state list do?

Lists all resources managed by Terraform.

---

## What does terraform show do?

Displays the current Terraform state in a readable format.

---

# Hands-on Completed

✅ Created variables.tf

✅ Created terraform.tfvars

✅ Modified main.tf to use variables

✅ Learned var.

✅ Created outputs.tf

✅ Used Resource References

✅ Executed terraform plan

✅ Executed terraform apply

✅ Viewed Terraform Outputs

✅ Learned Terraform State

✅ Executed terraform show

✅ Executed terraform state list

✅ Executed terraform state show

---

# Day 05 Summary

Today I transformed my Terraform code from hardcoded values to reusable code using variables. I learned how Terraform receives input values from terraform.tfvars, displays information using outputs, and manages infrastructure using the terraform.tfstate file. I also explored Terraform state commands that help inspect and troubleshoot managed infrastructure.