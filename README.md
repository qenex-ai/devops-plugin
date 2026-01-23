# DevOps Plugin for Claude Code

Enterprise-grade DevOps and Platform Engineering toolkit providing comprehensive knowledge, commands, agents, and automation across 41 skill domains.

## Overview

This plugin transforms Claude Code into a complete platform engineering assistant, covering:

- **Infrastructure & Cloud** - AWS, GCP, Azure, Kubernetes, containers
- **Deployment & CI/CD** - Multi-platform deployments, pipelines, testing
- **Security & Compliance** - Security scanning, compliance frameworks, IAM
- **Monitoring & Observability** - APM, logging, tracing, alerting
- **Developer Experience** - Local environments, tooling, documentation
- **Multi-Platform** - Web, iOS, Android, Web3, IoT, gaming

## Installation

```bash
# Clone to your plugins directory
git clone https://github.com/qenex/devops-plugin ~/.claude/plugins/devops

# Or link existing clone
ln -s /path/to/devops ~/.claude/plugins/devops
```

## Components

### Skills (41 domains)

Skills automatically activate when Claude detects relevant context:

| # | Skill | Description |
|---|-------|-------------|
| 1 | system-design | Architecture patterns, scalability, microservices |
| 2 | dns-domains | DNS records, registrar ops, SSL/TLS, CDN |
| 3 | build-systems | Webpack, Vite, Gradle, Xcode, Foundry |
| 4 | multi-platform-deploy | Web, iOS, Android, Web3 deployment |
| 5 | ci-cd-pipelines | GitHub Actions, testing, preview environments |
| 6 | monitoring-observability | APM, logging, alerting basics |
| 7 | security-compliance | Scanning, secrets management |
| 8 | database-operations | Migrations, backups, replication |
| 9 | container-orchestration | Kubernetes, Docker, Helm |
| 10 | cloud-providers | AWS, GCP, Azure resources |
| 11 | ux-ui-design | Design systems, accessibility, responsive |
| 12 | cost-optimization | FinOps, resource right-sizing |
| 13 | documentation-generation | API docs, diagrams, runbooks |
| 14 | incident-management | On-call, postmortems, response |
| 15 | testing-automation | E2E, load testing, chaos engineering |
| 16 | global-network | CDN, edge, global load balancing |
| 17 | ai-ml-operations | MLOps, model deployment, experiments |
| 18 | data-engineering | ETL, data lakes, streaming |
| 19 | compliance-frameworks | SOC2, HIPAA, GDPR, PCI-DSS |
| 20 | team-process-management | Agile, DORA metrics, planning |
| 21 | edge-iot-computing | Edge deployment, IoT management |
| 22 | blockchain-web3 | Smart contracts, DeFi, NFTs |
| 23 | api-management | Gateways, rate limiting, versioning |
| 24 | service-mesh | Istio, Linkerd, network policies |
| 25 | developer-experience | Local dev, tooling, onboarding |
| 26 | disaster-recovery | Backups, failover, business continuity |
| 27 | identity-access | IAM, SSO, RBAC, OAuth/OIDC |
| 28 | advanced-observability | Distributed tracing, SLOs, error budgets |
| 29 | message-queues-events | Kafka, RabbitMQ, event-driven |
| 30 | caching-strategies | Redis, Memcached, CDN caching |
| 31 | search-infrastructure | Elasticsearch, Algolia |
| 32 | feature-flags-experimentation | Feature toggles, A/B testing |
| 33 | mobile-devops | App stores, mobile CI/CD |
| 34 | gaming-infrastructure | Game servers, matchmaking |
| 35 | media-streaming | Video processing, live streaming |
| 36 | ecommerce-payments | Payment processing, Stripe |
| 37 | realtime-websocket | WebSocket, presence, collaboration |
| 38 | localization-i18n | Multi-language, regional deployment |
| 39 | graphql-infrastructure | GraphQL servers, federation |
| 40 | serverless-architecture | Lambda, Functions, patterns |
| 41 | legacy-modernization | Migration, strangler pattern |

### Commands

| Command | Description |
|---------|-------------|
| `/devops:deploy` | Deploy to any platform |
| `/devops:configure-dns` | DNS record management |
| `/devops:create-pipeline` | Generate CI/CD pipeline |
| `/devops:security-scan` | Run security analysis |
| `/devops:db-migrate` | Database migration helper |
| `/devops:k8s-deploy` | Kubernetes deployment |
| `/devops:monitor-setup` | Configure monitoring |
| `/devops:cloud-provision` | Provision cloud resources |
| `/devops:design-review` | UX/UI review |
| `/devops:cost-analyze` | Cost analysis |
| `/devops:generate-docs` | Generate documentation |
| `/devops:run-tests` | Execute test suites |
| `/devops:incident-create` | Create incident report |
| `/devops:ml-deploy` | Deploy ML model |
| `/devops:data-pipeline` | Create data pipeline |

### Agents

| Agent | Triggers |
|-------|----------|
| `infrastructure-auditor` | When reviewing infrastructure configs |
| `deployment-validator` | Before/after deployments |
| `security-analyzer` | When security review needed |
| `performance-optimizer` | When analyzing performance |
| `ux-reviewer` | When reviewing UI components |
| `cost-optimizer` | When analyzing cloud costs |
| `incident-responder` | During incident handling |
| `ml-ops-validator` | When validating ML deployments |
| `compliance-checker` | When checking compliance |

### Hooks

- **PreToolUse**: Validates infrastructure changes against project context
- **PostToolUse**: Verifies deployment configurations
- **SecurityCheck**: Scans for security issues in infrastructure code

## Integration

### With project-context-manager

This plugin integrates with `project-context-manager` for:
- Context-aware validation using project evaluation
- Secure credential retrieval for deployments
- Phase-based awareness during infrastructure changes

```bash
# Use project evaluation before deploy
/evaluate --quick && /devops:deploy production
```

## Configuration

Create `.claude/devops.local.md` to customize behavior:

```yaml
---
safety_mode: strict  # strict, moderate, permissive
auto_confirm: false  # require confirmation for destructive ops
preferred_cloud: aws  # aws, gcp, azure
kubernetes_context: production
---

## Custom Settings

Additional configuration notes...
```

## Safety Features

- **Destructive Operation Confirmation**: Configurable confirmation for dangerous operations
- **Security Scanning**: Automatic scanning for credentials and vulnerabilities
- **Cost Estimation**: Warns about potentially expensive operations
- **Rollback Support**: Maintains rollback capabilities for deployments

## Requirements

- Claude Code CLI
- Docker (for container operations)
- kubectl (for Kubernetes operations)
- Cloud CLI tools (aws, gcloud, az) as needed

## Contributing

Contributions welcome! Please submit PRs to:
https://github.com/qenex/devops-plugin

## License

MIT License - see LICENSE file

---

**Made by QENEX LTD** | UK Company #16523814
