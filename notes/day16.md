# Day 16 – Azure Standard Load Balancer

## Objective

Deploy and configure an Azure Standard Load Balancer to distribute incoming traffic to the web server VM and understand the components required for high availability.

---

## Architecture

```text
Internet
    │
    ▼
Standard Public IP
    │
    ▼
Azure Standard Load Balancer
    │
    ▼
Backend Pool
    │
    ▼
vm-web-terraform (NGINX)
```

---

## Resources Used

| Resource | Name |
|----------|------|
| Resource Group | rg-enterprise-dev |
| Virtual Machine | vm-web-terraform |
| Network Interface | vm-web-nic |
| Public IP | lb-public-ip |
| Load Balancer | web-load-balancer |
| Backend Pool | web-backend-pool |
| Health Probe | http-probe |
| Load Balancing Rule | http-rule |

---

## Steps Performed

### 1. Started the Virtual Machine

```bash
az vm start \
  --resource-group rg-enterprise-dev \
  --name vm-web-terraform
```

---

### 2. Created a Standard Public IP

```bash
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name lb-public-ip \
  --sku Standard \
  --allocation-method Static
```

Result:

- Public IP created successfully
- Static IP assigned

---

### 3. Created Azure Standard Load Balancer

```bash
az network lb create \
  --resource-group rg-enterprise-dev \
  --name web-load-balancer \
  --sku Standard \
  --public-ip-address lb-public-ip \
  --frontend-ip-name lb-frontend \
  --backend-pool-name web-backend-pool
```

Verified using:

```bash
az network lb show \
  --resource-group rg-enterprise-dev \
  --name web-load-balancer \
  --output table
```

Status:

- Provisioning State: Succeeded

---

### 4. Added VM to Backend Pool

Initially received:

```
ResourceNotFoundError
```

Issue:

The NIC IP configuration name was not `ipconfig1`.

Verified using:

```bash
az network nic show \
  --resource-group rg-enterprise-dev \
  --name vm-web-nic \
  --query "ipConfigurations[].name"
```

Output:

```
internal
```

Correct command:

```bash
az network nic ip-config address-pool add \
  --resource-group rg-enterprise-dev \
  --nic-name vm-web-nic \
  --ip-config-name internal \
  --lb-name web-load-balancer \
  --address-pool web-backend-pool
```

Verification:

```bash
az network nic show \
  --resource-group rg-enterprise-dev \
  --name vm-web-nic \
  --query "ipConfigurations[].loadBalancerBackendAddressPools[].id"
```

Backend pool association completed successfully.

---

### 5. Created Health Probe

```bash
az network lb probe create \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --name http-probe \
  --protocol Tcp \
  --port 80
```

Verified:

```bash
az network lb probe list \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --output table
```

Status:

- Health Probe created successfully

---

### 6. Created Load Balancing Rule

```bash
az network lb rule create \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --name http-rule \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name lb-frontend \
  --backend-pool-name web-backend-pool \
  --probe-name http-probe
```

Verified:

```bash
az network lb rule list \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --output table
```

Result:

- Rule created successfully

---

### 7. Retrieved Load Balancer Public IP

```bash
az network public-ip show \
  --resource-group rg-enterprise-dev \
  --name lb-public-ip \
  --query ipAddress \
  -o tsv
```

Output:

```
20.219.134.66
```

Application URL:

```
http://20.219.134.66
```

---

## Learning Outcomes

- Understood Azure Standard Load Balancer.
- Learned the purpose of Frontend IP configuration.
- Configured a Backend Address Pool.
- Created a Health Probe for backend monitoring.
- Configured a Load Balancing Rule.
- Associated a VM Network Interface with a backend pool.
- Learned how Azure distributes incoming traffic.

---

## Screenshots to Capture

1. Load Balancer Overview
2. Frontend IP Configuration
3. Backend Pool
4. VM NIC associated with Backend Pool
5. Health Probe
6. Load Balancing Rule
7. Browser showing application using Load Balancer Public IP

---

## Outcome

Successfully deployed and configured an Azure Standard Load Balancer with a backend web server, health monitoring, and traffic distribution, providing the foundation for highly available web applications in Azure.