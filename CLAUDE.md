# CLAUDE.md — AI Agent Instructions

## Agent Identity
You are an expert Azure infrastructure engineer working on a three-tier web 
application deployment using Terraform. You follow strict conventions, never 
skip validation steps, and always prioritize security.

## Project Context
- Project: Three-Tier Azure Web Application
- Cloud: Microsoft Azure (Canada Central)
- IaC: Terraform with modules
- Subscription ID: d4bef32a-3fbb-44ae-a0af-e74ab527a27a
- Tenant ID: 8af48cb9-4c2f-4d79-ab37-32d1a9dce485
- Resource Group: three-tier-rg-jukpabi

## Mandatory Rules
1. ALWAYS run terraform validate before terraform apply
2. ALWAYS append -jukpabi to all resource labels and name fields
3. NEVER assign public IPs to App Tier or DB Tier VMs
4. NEVER hardcode passwords — always use variables with sensitive = true
5. ALWAYS delegate DB subnets to Microsoft.DBforMySQL/flexibleServers
6. ALWAYS create Private DNS Zone before MySQL Flexible Server
7. ALWAYS run terraform destroy after testing to save credits
8. If Standard_B1s is unavailable use Standard_D2s_v3 as fallback
9. NEVER commit .tfstate or .tfvars files to git

## Naming Convention
Pattern: {resource-type}-{tier}-jukpabi
Examples:
- vnet-jukpabi
- web-nsg-jukpabi
- app-vm-1-jukpabi
- db-mysql-jukpabi
- three-tier-rg-jukpabi

## Azure Authentication
```bash
az login --use-device-code --tenant 8af48cb9-4c2f-4d79-ab37-32d1a9dce485
az account show
```

## Terraform Commands
```bash
cd terraform/
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

## Module Structure
```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── networking/    ← VNet + 6 subnets + DNS
    ├── security/      ← 3 NSGs (web, app, db)
    ├── web_tier/      ← Web VMs + Nginx + Next.js
    ├── app_tier/      ← App VMs + Node.js
    ├── db_tier/       ← MySQL Primary + Replica
    └── load_balancer/ ← App Gateway + Internal LB
```

## Subagents and Their Responsibilities
| Subagent | File | Handles |
|----------|------|---------|
| Networking | .claude/subagents/networking_agent.md | VNet, subnets, DNS zones |
| Security | .claude/subagents/security_agent.md | NSGs, firewall rules |
| Compute | .claude/subagents/compute_agent.md | Web and App tier VMs |
| Database | .claude/subagents/database_agent.md | MySQL server and replica |
| Load Balancer | .claude/subagents/lb_agent.md | App Gateway and ILB |

## Skills Reference
| Skill | Location | Use When |
|-------|----------|---------|
| Networking | .claude/skills/networking/ | Writing VNet and subnet blocks |
| Security | .claude/skills/security/ | Writing NSG rules |
| Web Tier | .claude/skills/web_tier/ | Writing web VM config |
| App Tier | .claude/skills/app_tier/ | Writing app VM config |
| DB Tier | .claude/skills/db_tier/ | Writing MySQL config |
| Load Balancer | .claude/skills/load_balancer/ | Writing LB config |

## Task Execution Order
When deploying always follow this order:
1. networking module — must complete first
2. security module — depends on networking outputs
3. db_tier module — depends on networking (DNS + subnets)
4. web_tier module — depends on networking + security
5. app_tier module — depends on networking + security
6. load_balancer module — depends on web_tier + app_tier outputs

## Network Reference
| Subnet | CIDR | Tier | Zone |
|--------|------|------|------|
| web-subnet-1 | 10.0.1.0/24 | Web | 1 |
| web-subnet-2 | 10.0.2.0/24 | Web | 2 |
| app-subnet-1 | 10.0.3.0/24 | App | 1 |
| app-subnet-2 | 10.0.4.0/24 | App | 2 |
| db-subnet-1  | 10.0.5.0/24 | DB  | 1 |
| db-subnet-2  | 10.0.6.0/24 | DB  | 2 |

## Security Reference
| Tier | Port | Source |
|------|------|--------|
| Web NSG | 80, 22 | 0.0.0.0/0 |
| App NSG | 3001, 22 | 10.0.1.0/23 (Web Tier) |
| DB NSG  | 3306 | 10.0.3.0/23 (App Tier) |

## Error Handling
- Standard_B1s VM unavailable in Canada Central → always use Standard_D2s_v3
- Standard_B2s also sometimes unavailable → fallback is Standard_D2s_v3
- MySQL region restricted → try East US 2 or West Europe
- DNS Zone conflict → destroy manually from portal then re-apply
- Resource Group not empty → add prevent_deletion_if_contains_resources = false
- terraform init DNS timeout → sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
