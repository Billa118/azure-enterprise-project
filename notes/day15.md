# Day 15 – Azure Managed Identity

## Objective

Learn how Azure resources securely authenticate to other Azure services without storing usernames, passwords, or client secrets.

---

## What is Managed Identity?

Managed Identity is an Azure feature that automatically creates and manages an identity for an Azure resource.

This identity can securely access Azure services using Azure Active Directory authentication.

---

## Why Managed Identity?

Without Managed Identity:

- Hardcoded passwords
- Client secrets
- Secret rotation
- Increased security risk

With Managed Identity:

- No stored credentials
- Automatic authentication
- Temporary Azure AD tokens
- RBAC-based authorization

---

## Enabled System Assigned Managed Identity

Virtual Machine:

```
vm-web-terraform
```

Identity Type:

```
SystemAssigned
```

---

## Granted Key Vault Access

Assigned Role:

```
Key Vault Secrets User
```

Scope:

```
Azure Key Vault (kvmanoj2026)
```

---

## Commands Used

Enable Managed Identity

```bash
az vm identity assign \
  --resource-group rg-enterprise-dev \
  --name vm-web-terraform
```

View Identity

```bash
az vm identity show \
  --resource-group rg-enterprise-dev \
  --name vm-web-terraform
```

Assign RBAC Role

```bash
az role assignment create \
  --assignee <principal-id> \
  --role "Key Vault Secrets User" \
  --scope <key-vault-id>
```

Verify Assignment

```bash
az role assignment list \
  --assignee <principal-id> \
  --scope <key-vault-id> \
  --output table
```

---

## Architecture

```
Azure AD
   │
   ▼
Managed Identity
   │
   ▼
VM
   │
   ▼
Azure Key Vault
   │
   ▼
Secrets
```

---

## Benefits

- Passwordless authentication
- Automatic credential management
- Secure Azure AD integration
- RBAC authorization
- Enterprise security best practice

---

## Key Learning

- Enabled a System Assigned Managed Identity.
- Granted the VM permission to access Azure Key Vault.
- Learned how Azure AD issues temporary access tokens.
- Eliminated the need for stored credentials.

---

## Next Topic

Day 16 – Azure Load Balancer