# Day 23 – Azure Application Gateway (Layer 7 Load Balancer)

## Objective
Deploy and configure an Azure Application Gateway to distribute HTTP traffic between two NGINX web servers.

---

# Architecture

```
                 Internet
                     │
                     ▼
         Public IP (4.213.50.85)
                     │
                     ▼
       Azure Application Gateway
             (Standard_v2)
                     │
          HTTP Listener (Port 80)
                     │
             Routing Rule (rule1)
                     │
              Backend Pool
          ┌──────────┴──────────┐
          ▼                     ▼
     vm-web-terraform      vm-web-02
        10.0.0.5             10.0.0.4
```

---

# Prerequisites

- Resource Group: `rg-enterprise-dev`
- Virtual Network: `Vnet01`
- Subnet: `AppGatewaySubnet`
- VM 1: `vm-web-terraform`
- VM 2: `vm-web-02`
- NGINX installed on both VMs
- Azure CLI installed

---

# Step 1: Verify Existing VMs

```bash
az vm list -d \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```
vm-web-terraform   Running
vm-web-02          Running
```

---

# Step 2: Verify Public IP

```bash
az network public-ip list \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```
appgw-public-ip
4.213.50.85
```

---

# Step 3: Create Application Gateway

```bash
az network application-gateway create \
  --resource-group rg-enterprise-dev \
  --name enterprise-appgw \
  --location centralindia \
  --sku Standard_v2 \
  --capacity 2 \
  --vnet-name Vnet01 \
  --subnet AppGatewaySubnet \
  --public-ip-address appgw-public-ip \
  --priority 100
```

---

# Step 4: Verify Deployment

```bash
az network application-gateway show \
  --resource-group rg-enterprise-dev \
  --name enterprise-appgw \
  --query "{Provisioning:provisioningState,State:operationalState}" \
  -o table
```

Output:

```
Provisioning    State
--------------  -------
Succeeded       Running
```

---

# Step 5: View Gateway Components

## Backend Pool

```bash
az network application-gateway address-pool list \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  -o table
```

Output:

```
appGatewayBackendPool
```

---

## HTTP Settings

```bash
az network application-gateway http-settings list \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  -o table
```

Output:

```
appGatewayBackendHttpSettings
Port : 80
Protocol : Http
```

---

## HTTP Listener

```bash
az network application-gateway http-listener list \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  -o table
```

Output:

```
appGatewayHttpListener
```

---

## Routing Rule

```bash
az network application-gateway rule list \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  -o table
```

Output:

```
rule1
Priority : 100
```

---

# Step 6: Get Private IP Addresses

```bash
az vm list-ip-addresses \
  --resource-group rg-enterprise-dev \
  -o table
```

Output:

```
vm-web-terraform   10.0.0.5
vm-web-02          10.0.0.4
```

---

# Step 7: Configure Backend Pool

Add the backend servers.

```bash
az network application-gateway address-pool update \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  --name appGatewayBackendPool \
  --servers 10.0.0.5 10.0.0.4
```

---

# Step 8: Verify Backend Pool

```bash
az network application-gateway address-pool show \
  --resource-group rg-enterprise-dev \
  --gateway-name enterprise-appgw \
  --name appGatewayBackendPool \
  --query backendAddresses
```

Expected Output:

```json
[
  {
    "ipAddress": "10.0.0.5"
  },
  {
    "ipAddress": "10.0.0.4"
  }
]
```

---

# Step 9: Check Backend Health

```bash
az network application-gateway show-backend-health \
  --resource-group rg-enterprise-dev \
  --name enterprise-appgw
```

Expected:

```
Health : Healthy
```

Both backend servers should be reported as **Healthy**.

---

# Step 10: Test Application Gateway

```bash
for i in {1..10}; do
    curl http://4.213.50.85
    echo
done
```

Sample Output:

```
Hello from WEB-01
Hello from WEB-02
Hello from WEB-01
Hello from WEB-02
Hello from WEB-01
Hello from WEB-01
Hello from WEB-02
Hello from WEB-02
Hello from WEB-01
Hello from WEB-01
```

This confirms that the Application Gateway is successfully routing requests to both backend web servers.

---

# Application Gateway Components

| Component | Purpose |
|-----------|---------|
| Public IP | Entry point for internet traffic |
| Listener | Receives HTTP/HTTPS requests |
| Backend Pool | Contains backend web servers |
| HTTP Settings | Defines protocol, port and timeout |
| Health Probe | Checks backend server availability |
| Routing Rule | Forwards requests to the backend pool |

---

# Standard Load Balancer vs Application Gateway

| Standard Load Balancer | Application Gateway |
|------------------------|---------------------|
| Layer 4 (TCP/UDP) | Layer 7 (HTTP/HTTPS) |
| Works at network layer | Works at application layer |
| TCP/UDP traffic | HTTP/HTTPS traffic |
| No URL inspection | URL-based routing |
| No SSL termination | SSL termination supported |
| No host-based routing | Host-based routing supported |
| No Web Application Firewall | WAF available (WAF_v2 SKU) |

---

# Real-World Use Cases

- Hosting multiple web applications behind a single public IP.
- Path-based routing (e.g., `/api`, `/admin`, `/images`).
- SSL/TLS termination to offload encryption from backend servers.
- Web Application Firewall (WAF) for protection against common web attacks.
- Host-based routing for multiple domains.
- Secure internet-facing web applications.

---

# Key Learnings

- Deployed an Azure Application Gateway (Standard_v2).
- Configured an HTTP listener and routing rule.
- Added backend web servers using private IP addresses.
- Verified backend health.
- Tested load distribution between two NGINX servers.
- Learned the difference between Layer 4 and Layer 7 load balancing.
- Understood the core components of an Application Gateway and common enterprise use cases.

---

# Result

✅ Successfully deployed and configured an Azure Application Gateway.

✅ Verified HTTP traffic distribution between `vm-web-terraform` and `vm-web-02`.

✅ Gained hands-on experience with Azure Layer 7 load balancing.