# Day 17 – Azure Application Gateway (Layer 7 Load Balancer)

## Objective

The objective of Day 17 was to understand and implement Azure Application Gateway, which is a Layer 7 (Application Layer) load balancer. Unlike Azure Load Balancer, Application Gateway can inspect HTTP/HTTPS traffic and perform intelligent request routing based on application-level information.

---

# Architecture

```
                 Internet
                     │
                     ▼
          Azure Application Gateway
                     │
             HTTP Listener (Port 80)
                     │
               Routing Rule
                     │
              Backend Pool
                     │
                     ▼
            VM (NGINX Web Server)
```

---

# Azure Resources Used

| Resource | Name |
|----------|------|
| Resource Group | rg-enterprise-dev |
| Virtual Network | Vnet01 |
| VM | vm-web-terraform |
| Application Gateway | app-gateway |
| Public IP | appgw-public-ip |
| Application Gateway Subnet | AppGatewaySubnet |

---

# Step 1 – Create Application Gateway Subnet

Application Gateway requires a dedicated subnet inside the Virtual Network.

Command:

```bash
az network vnet subnet create \
  --resource-group rg-enterprise-dev \
  --vnet-name Vnet01 \
  --name AppGatewaySubnet \
  --address-prefixes 10.0.3.0/24
```

Result:

- Successfully created a dedicated subnet for Application Gateway.

---

# Step 2 – Create Public IP

Created a Standard Static Public IP for the Application Gateway.

Command:

```bash
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name appgw-public-ip \
  --sku Standard \
  --allocation-method Static
```

Result:

- Public IP created successfully.

Assigned Public IP:

```
4.224.51.153
```

---

# Step 3 – Create Application Gateway

Initially, the deployment failed because the Azure API now requires a routing rule priority.

Error received:

```
ApplicationGatewayRequestRoutingRulePriorityCannotBeEmpty
```

Solution:

Added the routing rule priority while creating the Application Gateway.

Command:

```bash
az network application-gateway create \
  --resource-group rg-enterprise-dev \
  --name app-gateway \
  --location centralindia \
  --capacity 1 \
  --sku Standard_v2 \
  --public-ip-address appgw-public-ip \
  --vnet-name Vnet01 \
  --subnet AppGatewaySubnet \
  --servers 10.0.0.5 \
  --priority 100
```

Result:

- Application Gateway deployed successfully.

Deployment Status:

```
Provisioning State : Succeeded
Operational State  : Running
```

---

# Step 4 – Verify Backend Health

Checked whether the Application Gateway could communicate with the backend VM.

Command:

```bash
az network application-gateway show-backend-health \
  --resource-group rg-enterprise-dev \
  --name app-gateway
```

Result:

```
Backend Server : 10.0.0.5
Health         : Healthy
Probe Status   : Success. Received 200 status code
```

This confirmed that:

- NGINX was running.
- Backend server was reachable.
- Health probes were successful.

---

# Step 5 – Verify Public IP

Retrieved the public IP assigned to the Application Gateway.

Command:

```bash
az network public-ip show \
  --resource-group rg-enterprise-dev \
  --name appgw-public-ip \
  --query ipAddress \
  -o tsv
```

Output:

```
4.224.51.153
```

Accessed in browser:

```
http://4.224.51.153
```

Result:

- Successfully accessed the NGINX web page through the Application Gateway.

---

# Components Created

- Frontend IP Configuration
- Frontend Port (80)
- HTTP Listener
- Backend Address Pool
- Backend HTTP Settings
- Request Routing Rule
- Backend Health Monitoring

---

# Difference Between Azure Load Balancer and Application Gateway

| Azure Load Balancer | Azure Application Gateway |
|----------------------|---------------------------|
| Layer 4 | Layer 7 |
| TCP/UDP Traffic | HTTP/HTTPS Traffic |
| Network-based Routing | URL and Host-based Routing |
| No SSL Termination | SSL Termination Supported |
| No Web Application Firewall | Supports Web Application Firewall (WAF) |
| Simple Load Balancing | Intelligent Request Routing |

---

# Key Learning Outcomes

- Learned the purpose of Azure Application Gateway.
- Understood Layer 7 load balancing.
- Created a dedicated subnet for Application Gateway.
- Configured a Standard_v2 Application Gateway.
- Created a backend pool using the VM's private IP.
- Verified backend health using Azure Health Probes.
- Learned that recent Azure APIs require request routing rule priorities.
- Successfully accessed the application through the Application Gateway public IP.

---

# Screenshots Included

- Application Gateway Overview
- Public IP Configuration
- Backend Pool
- Backend Health (Healthy)
- HTTP Listener
- Routing Rule
- Browser showing NGINX page through Application Gateway

---

# Outcome

Successfully deployed an Azure Application Gateway (Standard_v2) with a dedicated subnet and configured it to route HTTP traffic to the NGINX web server running on the backend virtual machine. Verified successful deployment using backend health checks and confirmed application accessibility through the Application Gateway public IP.

---

# Commands Used

```bash
# Create Application Gateway subnet
az network vnet subnet create \
  --resource-group rg-enterprise-dev \
  --vnet-name Vnet01 \
  --name AppGatewaySubnet \
  --address-prefixes 10.0.3.0/24

# Create Public IP
az network public-ip create \
  --resource-group rg-enterprise-dev \
  --name appgw-public-ip \
  --sku Standard \
  --allocation-method Static

# Create Application Gateway
az network application-gateway create \
  --resource-group rg-enterprise-dev \
  --name app-gateway \
  --location centralindia \
  --capacity 1 \
  --sku Standard_v2 \
  --public-ip-address appgw-public-ip \
  --vnet-name Vnet01 \
  --subnet AppGatewaySubnet \
  --servers 10.0.0.5 \
  --priority 100

# Verify Backend Health
az network application-gateway show-backend-health \
  --resource-group rg-enterprise-dev \
  --name app-gateway

# Get Public IP
az network public-ip show \
  --resource-group rg-enterprise-dev \
  --name appgw-public-ip \
  --query ipAddress \
  -o tsv
```