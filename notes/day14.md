# Day 14 – Azure Key Vault & Secure Secret Management

## Objective

Learn how to securely store and manage secrets using Azure Key Vault instead of hardcoding sensitive values in Terraform.

---

## Why Azure Key Vault?

Hardcoding passwords inside Terraform files is insecure.

Example (Not Recommended):

```hcl
admin_password = "Password@123"
```

Azure Key Vault provides a secure location to store:

- VM Passwords
- API Keys
- Database Credentials
- Connection Strings
- Certificates

---

## Architecture

Terraform
        │
        ▼
Azure Key Vault
        │
        ▼
Secrets

---

## Created Azure Key Vault

Resource Group:

```
rg-enterprise-dev
```

Key Vault:

```
kvmanoj2026
```

Location:

```
Central India
```

---

## RBAC Authorization

Verified:

```
enableRbacAuthorization = true
```

Initially received:

```
ForbiddenByRbac
```

The issue was resolved after RBAC permissions propagated.

---

## Created Secret

Secret Name:

```
vmAdminPassword
```

Stored securely inside Azure Key Vault.

---

## Commands Used

Create Key Vault

```bash
az keyvault create \
  --name kvmanoj2026 \
  --resource-group rg-enterprise-dev \
  --location "Central India"
```

Store Secret

```bash
az keyvault secret set \
  --vault-name kvmanoj2026 \
  --name vmAdminPassword \
  --value "<PASSWORD>"
```

List Secrets

```bash
az keyvault secret list \
  --vault-name kvmanoj2026 \
  --output table
```

Retrieve Secret

```bash
az keyvault secret show \
  --vault-name kvmanoj2026 \
  --name vmAdminPassword \
  --query value \
  --output tsv
```

---

## Terraform Sensitive Variable

```hcl
variable "admin_password" {
  description = "Virtual Machine Administrator Password"
  type        = string
  sensitive   = true
}
```

---

## Benefits

- Centralized secret management
- Improved security
- No hardcoded passwords
- Supports CI/CD pipelines
- Enterprise best practice

---

## Key Learning

- Azure Key Vault stores secrets securely.
- RBAC controls access to secrets.
- Terraform supports sensitive variables.
- Production deployments should avoid storing passwords in source code.

---

## Next Topic

# Day 15 – Azure Managed Identity