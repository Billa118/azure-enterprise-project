# Day 11 – Terraform Workspaces

## Objective

Learn how Terraform Workspaces allow the same Terraform configuration to manage multiple environments such as Development, Testing, and Production while maintaining separate state files.

---

## What are Terraform Workspaces?

A Terraform workspace is an isolated instance of a Terraform state.

Each workspace maintains its own:

- Terraform state file
- Infrastructure resources
- Outputs
- Variables (when configured)

This allows a single Terraform project to be reused across multiple environments.

---

## Why are Workspaces Used?

Instead of creating separate Terraform projects for every environment, a single codebase can be used.

Example:

```
Terraform Code
      │
      ├── Development
      ├── Testing
      └── Production
```

Benefits:

- Reuse the same Terraform code
- Isolate infrastructure between environments
- Maintain separate state files
- Simplify environment management

---

## Default Workspace

Terraform automatically creates one workspace named:

```
default
```

Verified using:

```bash
terraform workspace list
```

Output:

```
* default
```

---

## Creating Additional Workspaces

Created three workspaces for different environments.

Development

```bash
terraform workspace new dev
```

Testing

```bash
terraform workspace new test
```

Production

```bash
terraform workspace new prod
```

---

## Listing Workspaces

Executed:

```bash
terraform workspace list
```

Output:

```
default
dev
* prod
test
```

The asterisk (*) indicates the currently active workspace.

---

## Switching Between Workspaces

Terraform allows switching between environments.

Examples:

```bash
terraform workspace select default
```

```bash
terraform workspace select dev
```

```bash
terraform workspace select test
```

```bash
terraform workspace select prod
```

---

## Important Observation

Each workspace maintains its own Terraform state.

For example:

```
default
    └── terraform.tfstate

dev
    └── terraform.tfstate

test
    └── terraform.tfstate

prod
    └── terraform.tfstate
```

Resources managed in one workspace are not visible to another workspace.

---

## Enterprise Use Case

Example environments:

| Workspace | Purpose |
|-----------|----------|
| default | Initial deployment |
| dev | Development environment |
| test | Testing and QA |
| prod | Production deployment |

Teams can use the same Terraform code while keeping environments isolated.

---

## Commands Used

List workspaces

```bash
terraform workspace list
```

Create workspace

```bash
terraform workspace new <workspace-name>
```

Switch workspace

```bash
terraform workspace select <workspace-name>
```

Show current workspace

```bash
terraform workspace show
```

Delete workspace (when no longer required)

```bash
terraform workspace delete <workspace-name>
```

---

## Key Learning

- Learned the purpose of Terraform Workspaces.
- Created multiple workspaces.
- Switched between workspaces.
- Understood that each workspace maintains its own state.
- Learned how enterprises separate Development, Testing, and Production environments.

---

## Note

The existing Azure infrastructure in this project was created using the **default** workspace.

Changing resource names or applying Terraform from another workspace would create a separate infrastructure because each workspace has an independent state.

Therefore, workspaces were explored as a learning exercise without modifying the deployed infrastructure.

---

## Project Status

Completed:

- Azure Resource Group
- Virtual Network
- Subnets
- Network Security Groups
- Public IP
- Linux Virtual Machine
- NGINX Deployment
- Terraform Modules
- Azure Storage Account
- Remote Terraform Backend
- Terraform Workspaces

---

## Next Topic

# Day 12 – Terraform Module Refactoring

Topics:

- Networking Module
- Compute Module
- Security Module
- Storage Module
- Reusable Infrastructure
- Enterprise Project Structure