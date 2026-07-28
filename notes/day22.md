# Day 22 – Azure Standard Load Balancer & High Availability

## Objective

The objective of this lab was to configure an Azure Standard Load Balancer to distribute incoming HTTP traffic between two Ubuntu virtual machines running NGINX. This demonstrates a highly available web application architecture where traffic is automatically routed to healthy backend servers.

---

## Architecture

```text
                Internet
                    │
        Public IP (lb-public-ip)
                    │
      Azure Standard Load Balancer
                    │
      ┌─────────────┴─────────────┐
      │                           │
vm-web-terraform              vm-web-02
10.0.0.5                      10.0.0.4
      │                           │
    NGINX                      NGINX
      │                           │
Hello from WEB-01           Hello from WEB-02
```

---

# Resources Used

| Resource | Name |
|----------|------|
| Resource Group | rg-enterprise-dev |
| Virtual Network | Vnet01 |
| Load Balancer | web-load-balancer |
| Public IP | lb-public-ip |
| Backend Pool | web-backend-pool |
| Health Probe | http-probe |
| Load Balancing Rule | http-rule |
| VM-1 | vm-web-terraform |
| VM-2 | vm-web-02 |

---

# Prerequisites

- Existing Ubuntu VM (`vm-web-terraform`)
- Existing Virtual Network (`Vnet01`)
- Azure CLI installed and configured
- NGINX installed on both virtual machines

---

# Implementation Steps

## Step 1 – Verify Existing Resources

Verified that the existing VM and networking resources were available.

```bash
az vm list -d -o table
```

---

## Step 2 – Deploy Second Web Server

Created a second Ubuntu VM inside the WEB subnet.

VM Name:

```
vm-web-02
```

---

## Step 3 – Install NGINX

Installed NGINX on both virtual machines.

```bash
sudo apt update
sudo apt install nginx -y
```

Verified the service:

```bash
systemctl status nginx
```

---

## Step 4 – Configure Test Pages

### WEB-01

```html
<h1>Hello from WEB-01</h1>
```

### WEB-02

```html
<h1>Hello from WEB-02</h1>
```

Verified both pages using their individual public IP addresses.

---

## Step 5 – Create Standard Public IP

```bash
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name lb-public-ip \
  --sku Standard
```

---

## Step 6 – Create Azure Standard Load Balancer

```bash
az network lb create \
  --resource-group rg-enterprise-dev \
  --name web-load-balancer \
  --sku Standard \
  --public-ip-address lb-public-ip \
  --frontend-ip-name web-frontend \
  --backend-pool-name web-backend-pool
```

---

## Step 7 – Create Health Probe

```bash
az network lb probe create \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --name http-probe \
  --protocol Http \
  --port 80 \
  --path /
```

---

## Step 8 – Create Load Balancing Rule

```bash
az network lb rule create \
  --resource-group rg-enterprise-dev \
  --lb-name web-load-balancer \
  --name http-rule \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name web-frontend \
  --backend-pool-name web-backend-pool \
  --probe-name http-probe
```

---

## Step 9 – Add First VM to Backend Pool

```bash
az network nic ip-config address-pool add \
  --resource-group rg-enterprise-dev \
  --nic-name vm-web-nic \
  --ip-config-name internal \
  --lb-name web-load-balancer \
  --address-pool web-backend-pool
```

---

## Step 10 – Add Second VM to Backend Pool

```bash
az network nic ip-config address-pool add \
  --resource-group rg-enterprise-dev \
  --nic-name vm-web-02VMNic \
  --ip-config-name ipconfigvm-web-02 \
  --lb-name web-load-balancer \
  --address-pool web-backend-pool
```

---

## Step 11 – Retrieve Load Balancer Public IP

```bash
az network public-ip show \
  --resource-group rg-enterprise-dev \
  --name lb-public-ip \
  --query ipAddress \
  -o tsv
```

Output:

```
4.224.32.167
```

---

## Step 12 – Validate Load Balancing

Executed multiple HTTP requests against the Load Balancer.

```bash
for i in {1..10}; do
    curl http://4.224.32.167
    echo
done
```

Sample Output:

```
Hello from WEB-02
Hello from WEB-01
Hello from WEB-02
Hello from WEB-02
Hello from WEB-01
Hello from WEB-02
Hello from WEB-02
Hello from WEB-02
Hello from WEB-02
Hello from WEB-01
```

The responses confirm that requests are being distributed across both backend web servers.

---

# Issues Encountered

## 1. Incorrect NIC IP Configuration Name

Initially attempted to attach NICs using:

```
ipconfig1
```

Actual IP configuration names were:

- VM-1 → `internal`
- VM-2 → `ipconfigvm-web-02`

Resolved by verifying the NIC configuration using:

```bash
az network nic show
```

---

## 2. ResourceNotFoundError

Encountered while adding NICs to the backend pool.

Cause:

Incorrect IP configuration name.

Resolution:

Used the correct IP configuration names.

---

## 3. InvalidResourceReference

While creating the Load Balancing Rule, Azure returned an error indicating that the health probe did not exist.

Resolution:

Created the health probe before creating the load balancing rule.

---

# Key Learnings

- Azure Standard Load Balancer provides Layer 4 (TCP/UDP) load balancing.
- Backend Pools group multiple virtual machines behind a single frontend IP.
- Health Probes continuously monitor backend VM availability.
- Only healthy backend instances receive client traffic.
- Azure Load Balancer distributes traffic using a hash-based algorithm rather than strict round-robin.
- Correct NIC IP configuration names are required when associating virtual machines with backend pools.

---

# Screenshots to Capture

- Resource Group overview
- Virtual Machines
- Load Balancer Overview
- Frontend IP Configuration
- Backend Pool
- Health Probe
- Load Balancing Rule
- Public IP
- Browser showing WEB-01
- Browser showing WEB-02
- Terminal showing successful load balancing using `curl`

---

# Outcome

Successfully deployed and configured an Azure Standard Load Balancer with two Ubuntu web servers. Created the frontend IP configuration, backend pool, health probe, and load balancing rule, associated both virtual machines with the backend pool, and verified successful traffic distribution between the servers, demonstrating a basic high-availability architecture.