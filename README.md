# Three-Tier Azure Web Application

A production-grade three-tier web application deployed on Microsoft Azure 
using Terraform Infrastructure as Code. Built with Next.js frontend, 
Node.js backend, and MySQL database — each in isolated network tiers.

---

## Architecture
```
                        ┌─────────────────┐
                        │    INTERNET     │
                        └────────┬────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Application Gateway   │
                    │     (Public LB)         │
                    │     Port 80             │
                    └────────────┬────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │              WEB TIER                       │
          │    Public Subnets — Zone 1 + Zone 2         │
          │    10.0.1.0/24 | 10.0.2.0/24               │
          │    Ubuntu VMs running Next.js via Nginx     │
          └──────────────────────┬──────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Internal Load         │
                    │   Balancer (ILB)        │
                    │   Port 3001             │
                    └────────────┬────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │              APP TIER                       │
          │    Private Subnets — Zone 1 + Zone 2        │
          │    10.0.3.0/24 | 10.0.4.0/24               │
          │    Ubuntu VMs running Node.js API           │
          │    No Public IP                             │
          └──────────────────────┬──────────────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │             DATABASE TIER                   │
          │    Private Subnets — Zone 1 + Zone 2        │
          │    10.0.5.0/24 | 10.0.6.0/24               │
          │    MySQL Flexible Server + Read Replica     │
          │    No Public Access                         │
          └─────────────────────────────────────────────┘
```

---

## Prerequisites

### Tools Required
| Tool | Version | Install |
|------|---------|---------|
| Terraform | >= 1.0 | https://developer.hashicorp.com/terraform/downloads |
| Azure CLI | >= 2.0 | https://docs.microsoft.com/en-us/cli/azure/install-azure-cli |
| Git | >= 2.0 | https://git-scm.com/downloads |
| Claude Code | Latest | https://claude.ai/code |
| Node.js | >= 18 | https://nodejs.org |

### Azure Requirements
- Active Azure subscription with sufficient credits
- Contributor role on the subscription
- Azure CLI authenticated

### Verify Prerequisites
```bash
terraform -version
az --version
git --version
claude --version
node -v
az account show
```

---

## Project Structure
```
three-tier-azure-app/
├── CLAUDE.md                    ← AI agent instructions
├── README.md                    ← This file
├── .gitignore
├── .claude/
│   ├── subagents/               ← Claude Code subagent definitions
│   │   ├── networking_agent.md
│   │   ├── security_agent.md
│   │   ├── compute_agent.md
│   │   ├── database_agent.md
│   │   └── lb_agent.md
│   └── skills/                  ← Reusable Terraform patterns
│       ├── networking/
│       ├── security/
│       ├── web_tier/
│       ├── app_tier/
│       ├── db_tier/
│       └── load_balancer/
├── terraform/
│   ├── main.tf                  ← Root orchestrator
│   ├── variables.tf             ← Global variables
│   ├── outputs.tf               ← Global outputs
│   └── modules/
│       ├── networking/          ← VNet + 6 subnets
│       ├── security/            ← 3 NSGs
│       ├── web_tier/            ← Web VMs + Nginx
│       ├── app_tier/            ← App VMs + Node.js
│       ├── db_tier/             ← MySQL + Replica
│       └── load_balancer/       ← App Gateway + ILB
├── scripts/                     ← Helper scripts
└── docs/                        ← Additional documentation
```

---

## Network Design

| Subnet | CIDR | Tier | Zone | Type |
|--------|------|------|------|------|
| web-subnet-1 | 10.0.1.0/24 | Web | Zone 1 | Public |
| web-subnet-2 | 10.0.2.0/24 | Web | Zone 2 | Public |
| app-subnet-1 | 10.0.3.0/24 | App | Zone 1 | Private |
| app-subnet-2 | 10.0.4.0/24 | App | Zone 2 | Private |
| db-subnet-1  | 10.0.5.0/24 | DB  | Zone 1 | Private |
| db-subnet-2  | 10.0.6.0/24 | DB  | Zone 2 | Private |

---

## Security Design

| Tier | NSG | Port | Source | Purpose |
|------|-----|------|--------|---------|
| Web | web-nsg-jukpabi | 80 | 0.0.0.0/0 | HTTP from internet |
| Web | web-nsg-jukpabi | 22 | 0.0.0.0/0 | SSH access |
| App | app-nsg-jukpabi | 3001 | 10.0.1.0/23 | Web Tier only |
| App | app-nsg-jukpabi | 22 | 10.0.1.0/23 | SSH from Web Tier |
| DB  | db-nsg-jukpabi  | 3306 | 10.0.3.0/23 | App Tier only |

---

## Deployment Guide

### Step 1 — Clone the Repository
```bash
git clone <your-repo-url>
cd three-tier-azure-app
```

### Step 2 — Authenticate with Azure
```bash
az login --use-device-code --tenant <your-tenant-id>
az account show
```

### Step 3 — Initialize Terraform
```bash
cd terraform
terraform init
```

### Step 4 — Validate Configuration
```bash
terraform validate
```

### Step 5 — Preview the Deployment
```bash
terraform plan
```

### Step 6 — Deploy
```bash
terraform apply -auto-approve
```

### Step 7 — Get Outputs
```bash
terraform output
```

### Step 8 — Destroy When Done
```bash
terraform destroy -auto-approve
```

---

## Application Details

### Web Tier — Next.js Frontend
- Runtime: Node.js 18
- Framework: Next.js
- Web Server: Nginx (reverse proxy)
- Port: 80
- Subnet: Public (web-subnet-1, web-subnet-2)

### App Tier — Node.js Backend
- Runtime: Node.js 18
- Framework: Express.js
- Process Manager: PM2
- Port: 3001
- Subnet: Private (app-subnet-1, app-subnet-2)
- Public IP: None

### Database Tier — MySQL
- Engine: MySQL 8.0
- Service: Azure Database for MySQL Flexible Server
- Primary Zone: Zone 1
- Replica Zone: Zone 2
- Public Access: Disabled
- VNet Integration: Private DNS Zone

---

## Cost Estimate

| Resource | Qty | Est. Cost/hr |
|----------|-----|-------------|
| Web VMs (Standard_D2s_v3) | 2 | ~$0.20 each |
| App VMs (Standard_D2s_v3) | 2 | ~$0.20 each |
| Application Gateway | 1 | ~$0.25 |
| Internal Load Balancer | 1 | ~$0.03 |
| MySQL Primary + Replica | 2 | ~$0.10 each |
| **Total** | | **~$1.08/hr** |

> Always run terraform destroy after testing!

---

## Troubleshooting

### VM Size Unavailable (409 Conflict)
```
Error: SkuNotAvailable: Standard_B1s
```
Fix: Change VM size to `Standard_D2s_v3` in variables.tf

### MySQL Region Restricted
```
Error: ProvisioningDisabled
```
Fix: Change region to `East US 2` or `West Europe`

### DNS Zone Conflict
```
Error: creating Virtual Network Link — polling failed
```
Fix: Go to Azure Portal → Private DNS Zones → delete manually → re-apply

### Resource Group Not Empty on Destroy
```
Error: Resource Group still contains Resources
```
Fix: Add to provider block:
```hcl
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
```

### terraform init DNS Timeout
```
Error: Could not connect to registry.terraform.io
```
Fix:
```bash
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
terraform init
```

---

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run terraform validate
5. Submit a pull request

---

## License
MIT

---

## Author
Joy Ukpabi — March 2026
