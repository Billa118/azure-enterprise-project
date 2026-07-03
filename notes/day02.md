# Day 02 - Resource Groups

## What is a Resource Group?

A Resource Group is a logical container that stores related Azure resources.

Example:

rg-enterprise-dev

Resources inside it:

- Virtual Machine
- Virtual Network
- Storage Account
- Network Security Group
- Key Vault

---

## Why Resource Groups?

- Organize resources
- Apply permissions (RBAC)
- Track costs
- Delete an environment together
- Apply resource locks

---

## Naming Convention

Development

rg-enterprise-dev

Testing

rg-enterprise-test

Production

rg-enterprise-prod

---

## Best Practices

- One application per Resource Group
- Use meaningful names
- Keep development and production separate
- Apply tags for cost tracking

---

## Interview Questions

### What is a Resource Group?

A Resource Group is a logical container used to organize and manage related Azure resources.

### Can a resource belong to multiple Resource Groups?

No.

Each Azure resource belongs to only one Resource Group.

---

## Hands-on

Created Resource Group:

rg-enterprise-dev