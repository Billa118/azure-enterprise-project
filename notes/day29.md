# Day 29 – Azure DevOps CI/CD Pipeline

## Objective

Build a Continuous Integration (CI) pipeline using Azure DevOps by connecting a GitHub repository and executing a YAML-based pipeline on a Microsoft-hosted build agent.

---

## Azure Services & Tools Used

- Azure DevOps
- Azure Pipelines
- GitHub
- Microsoft-hosted Agent
- YAML Pipeline

---

## Resources Used

| Resource | Name |
|----------|------|
| Azure DevOps Organization | billamanoj118 |
| Azure DevOps Project | Azure-Enterprise-Project |
| GitHub Repository | azure-enterprise-project |
| Pipeline | Billa118.azure-enterprise-project |
| Pipeline File | azure-pipelines.yml |
| Build Agent | Microsoft-hosted Ubuntu |

---

## Implementation Steps

### Step 1 – Create Azure DevOps Organization

Created an Azure DevOps organization using a Microsoft account.

---

### Step 2 – Create Azure DevOps Project

Created a new project with the following configuration:

- Project Name: Azure-Enterprise-Project
- Visibility: Private
- Version Control: Git
- Process: Agile

---

### Step 3 – Connect GitHub Repository

Connected the GitHub repository:

```
azure-enterprise-project
```

Installed and authorized the **Azure Pipelines GitHub App** to allow Azure DevOps to access the repository.

---

### Step 4 – Create YAML Pipeline

Created a new pipeline using a Starter Pipeline.

Added the pipeline configuration in:

```
azure-pipelines.yml
```

The pipeline included the following stages:

- Checkout Repository
- Project Information
- Build
- Validation
- Deploy
- Finish

---

### Step 5 – Commit Pipeline

Saved the pipeline configuration directly to the **main** branch.

Azure DevOps automatically committed the `azure-pipelines.yml` file to the GitHub repository.

---

### Step 6 – Run Pipeline

Triggered the pipeline execution.

Initially, the pipeline failed because a Microsoft-hosted build agent was not allocated.

Error observed:

```
No agent found in pool Azure Pipelines which satisfies the specified demands:
Agent.Version -gtVersion 2.163.1
```

---

### Step 7 – Troubleshooting

Performed the following checks:

- Verified Azure Pipelines Agent Pool
- Verified Microsoft-hosted Parallel Jobs
- Checked Agent Status
- Validated YAML syntax
- Confirmed `ubuntu-latest` build image
- Re-ran the pipeline

The subsequent execution completed successfully.

---

## Pipeline YAML

```yaml
trigger:
- main

pool:
  vmImage: ubuntu-latest

steps:

- checkout: self

- script: |
    echo "===================================="
    echo "Azure Enterprise Project"
    echo "===================================="
    pwd
    ls -la
  displayName: "Project Information"

- script: |
    echo "Starting Build..."
    sleep 2
    echo "Build Successful"
  displayName: "Build"

- script: |
    echo "Running Validation..."
    sleep 2
    echo "Validation Successful"
  displayName: "Validation"

- script: |
    echo "Deploying Application..."
    sleep 2
    echo "Deployment Successful"
  displayName: "Deploy"

- script: |
    echo "Pipeline Completed Successfully!"
  displayName: "Finish"
```

---

## Verification

Successfully verified:

- GitHub repository connected
- Azure Pipeline created
- YAML pipeline executed
- Build agent allocated successfully
- Pipeline completed successfully

---

## Learning Outcomes

- Understood Azure DevOps architecture
- Connected GitHub with Azure DevOps
- Created a YAML-based pipeline
- Used a Microsoft-hosted build agent
- Executed a Continuous Integration (CI) pipeline
- Diagnosed and resolved a temporary agent allocation issue
- Learned how Azure DevOps automatically builds repositories from YAML definitions

---

## Screenshots

Include the following screenshots:

1. Azure DevOps Organization
2. Azure DevOps Project
3. GitHub Repository Connection
4. Azure Pipelines GitHub App Authorization
5. `azure-pipelines.yml`
6. Initial Pipeline Error
7. Successful Pipeline Execution
8. Pipeline Summary

---

## Conclusion

Successfully integrated GitHub with Azure DevOps and created a YAML-based CI pipeline. The pipeline automatically checked out the repository, executed build and validation stages, and completed successfully using a Microsoft-hosted Ubuntu agent. During implementation, a temporary agent allocation issue was investigated and resolved by verifying the Azure DevOps environment and rerunning the pipeline.