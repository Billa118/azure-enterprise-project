# Day 25 – Azure Key Vault (Secrets Management)

## Objective

Learn how to securely store, retrieve, and manage secrets using Azure Key Vault with Azure RBAC.

---

# Architecture

```
                    Azure AD
                        │
                        ▼
               Azure RBAC Permissions
                        │
                        ▼
                Azure Key Vault
         ┌──────────┬───────────┬───────────┐
         ▼          ▼           ▼
   Database      API Keys   Connection
   Password                   Strings
         ▲
         │
         ▼
   Azure VM / Web App / AKS
```

---

# What is Azure Key Vault?

Azure Key Vault is a cloud service used to securely store and manage:

- Secrets
- Passwords
- API Keys
- Certificates
- Encryption Keys
- Connection Strings

Instead of storing sensitive information in source code or configuration files, applications retrieve secrets securely from Azure Key Vault.

---

# Why Use Key Vault?

## Without Key Vault

```python
db_password = "Password123"
api_key = "abcd1234"
```

Problems:

- Passwords exposed in code
- Risk of accidental Git commits
- Difficult to rotate credentials
- Poor security

---

## With Key Vault

```python
db_password = keyvault.get_secret("DatabasePassword")
```

Benefits:

- Secrets stored securely
- Centralized management
- Access controlled using Azure RBAC
- Easy secret rotation
- Enterprise security compliance

---

# Resource Details

| Resource | Value |
|----------|-------|
| Resource Group | rg-enterprise-dev |
| Location | centralindia |
| Key Vault | kv-enterprise-manoj |

---

# Step 1 – Verify Key Vault

```bash
az keyvault list \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```
Location      Name                 ResourceGroup
------------  -------------------  -----------------
centralindia  kv-enterprise-manoj  rg-enterprise-dev
```

---

# Step 2 – Check RBAC Mode

```bash
az keyvault show \
  --name kv-enterprise-manoj \
  --query "{Vault:name,RBAC:properties.enableRbacAuthorization}" \
  -o table
```

Output:

```
Vault                RBAC
-------------------  ------
kv-enterprise-manoj  True
```

This confirms the Key Vault uses **Azure RBAC** instead of legacy Access Policies.

---

# Step 3 – Get Current User Object ID

```bash
az ad signed-in-user show \
  --query "{ObjectId:id,User:userPrincipalName}" \
  -o table
```

Example Output:

```
ObjectId                              User
------------------------------------  -----------------------------------
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  user@example.com
```

---

# Step 4 – Assign Key Vault Administrator Role

```bash
az role assignment create \
  --assignee-object-id <OBJECT_ID> \
  --assignee-principal-type User \
  --role "Key Vault Administrator" \
  --scope $(az keyvault show \
      --name kv-enterprise-manoj \
      --query id \
      -o tsv)
```

This grants permission to create, update, delete, and retrieve secrets.

---

# Step 5 – Store a Secret

```bash
az keyvault secret set \
  --vault-name kv-enterprise-manoj \
  --name DatabasePassword \
  --value MySecurePassword123!
```

Result:

```
DatabasePassword
Stored Successfully
```

---

# Step 6 – Store an API Key

```bash
az keyvault secret set \
  --vault-name kv-enterprise-manoj \
  --name APIKey \
  --value abcd-1234-xyz
```

---

# Step 7 – Store a Connection String

```bash
az keyvault secret set \
  --vault-name kv-enterprise-manoj \
  --name StorageConnectionString \
  --value "DefaultEndpointsProtocol=https;AccountName=storage;AccountKey=key123;"
```

---

# Step 8 – List Secrets

```bash
az keyvault secret list \
  --vault-name kv-enterprise-manoj \
  -o table
```

Expected Output:

```
Name
------------------------
DatabasePassword
APIKey
StorageConnectionString
```

---

# Step 9 – Retrieve a Secret

```bash
az keyvault secret show \
  --vault-name kv-enterprise-manoj \
  --name DatabasePassword \
  --query value \
  -o tsv
```

Output:

```
MySecurePassword123!
```

---

# Step 10 – Update a Secret

```bash
az keyvault secret set \
  --vault-name kv-enterprise-manoj \
  --name DatabasePassword \
  --value NewPassword@2026
```

Retrieve the updated value:

```bash
az keyvault secret show \
  --vault-name kv-enterprise-manoj \
  --name DatabasePassword \
  --query value \
  -o tsv
```

Output:

```
NewPassword@2026
```

---

# Step 11 – View Key Vault Details

```bash
az keyvault show \
  --name kv-enterprise-manoj \
  -o table
```

Output:

```
Location      Name                 ResourceGroup
------------  -------------------  -----------------
centralindia  kv-enterprise-manoj  rg-enterprise-dev
```

---

# Azure RBAC Roles

| Role | Purpose |
|------|---------|
| Key Vault Administrator | Full management of Key Vault |
| Key Vault Secrets Officer | Manage secrets only |
| Key Vault Secrets User | Read secrets |
| Key Vault Reader | View Key Vault metadata |

---

# Key Vault Objects

| Object | Description |
|---------|-------------|
| Secret | Passwords, API Keys, Tokens, Connection Strings |
| Key | Encryption and Decryption Keys |
| Certificate | SSL/TLS Certificates |

---

# Real-World Use Cases

- Database passwords
- Azure Storage account keys
- API tokens
- OAuth client secrets
- SSL certificates
- SSH private keys
- JWT signing keys

---

# Security Best Practices

- Never hardcode secrets in source code.
- Store sensitive information in Azure Key Vault.
- Use Azure RBAC to control access.
- Rotate secrets periodically.
- Grant least-privilege access to users and applications.
- Use Managed Identities to access Key Vault from Azure services.

---

# Key Learnings

- Created and verified an Azure Key Vault.
- Enabled Azure RBAC authorization.
- Assigned the Key Vault Administrator role.
- Stored multiple secrets securely.
- Retrieved and updated secrets using Azure CLI.
- Understood the difference between secrets, keys, and certificates.
- Learned enterprise best practices for secure secret management.

---

# Result

✅ Successfully configured Azure Key Vault.

✅ Stored and managed secrets securely.

✅ Configured Azure RBAC for Key Vault access.

✅ Gained hands-on experience with enterprise-grade secrets management.