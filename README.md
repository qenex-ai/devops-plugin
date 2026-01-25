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

Skills automatically activate when Claude detects relevant context. See [`skills/`](skills/) for full documentation.

| # | Skill | Description |
|---|-------|-------------|
| 1 | [system-design](skills/system-design/SKILL.md) | Architecture patterns, scalability, microservices |
| 2 | [dns-domains](skills/dns-domains/SKILL.md) | DNS records, registrar ops, SSL/TLS, CDN |
| 3 | [build-systems](skills/build-systems/SKILL.md) | Webpack, Vite, Gradle, Xcode, Foundry |
| 4 | [multi-platform-deploy](skills/multi-platform-deploy/SKILL.md) | Web, iOS, Android, Web3 deployment |
| 5 | [ci-cd-pipelines](skills/ci-cd-pipelines/SKILL.md) | GitHub Actions, testing, preview environments |
| 6 | [monitoring-observability](skills/monitoring-observability/SKILL.md) | APM, logging, alerting basics |
| 7 | [security-compliance](skills/security-compliance/SKILL.md) | Scanning, secrets management |
| 8 | [database-operations](skills/database-operations/SKILL.md) | Migrations, backups, replication |
| 9 | [container-orchestration](skills/container-orchestration/SKILL.md) | Kubernetes, Docker, Helm |
| 10 | [cloud-providers](skills/cloud-providers/SKILL.md) | AWS, GCP, Azure resources |
| 11 | [ux-ui-design](skills/ux-ui-design/SKILL.md) | Design systems, accessibility, responsive |
| 12 | [cost-optimization](skills/cost-optimization/SKILL.md) | FinOps, resource right-sizing |
| 13 | [documentation-generation](skills/documentation-generation/SKILL.md) | API docs, diagrams, runbooks |
| 14 | [incident-management](skills/incident-management/SKILL.md) | On-call, postmortems, response |
| 15 | [testing-automation](skills/testing-automation/SKILL.md) | E2E, load testing, chaos engineering |
| 16 | [global-network](skills/global-network/SKILL.md) | CDN, edge, global load balancing |
| 17 | [ai-ml-operations](skills/ai-ml-operations/SKILL.md) | MLOps, model deployment, experiments |
| 18 | [data-engineering](skills/data-engineering/SKILL.md) | ETL, data lakes, streaming |
| 19 | [compliance-frameworks](skills/compliance-frameworks/SKILL.md) | SOC2, HIPAA, GDPR, PCI-DSS |
| 20 | [team-process-management](skills/team-process-management/SKILL.md) | Agile, DORA metrics, planning |
| 21 | [edge-iot-computing](skills/edge-iot-computing/SKILL.md) | Edge deployment, IoT management |
| 22 | [blockchain-web3](skills/blockchain-web3/SKILL.md) | Smart contracts, DeFi, NFTs |
| 23 | [api-management](skills/api-management/SKILL.md) | Gateways, rate limiting, versioning |
| 24 | [service-mesh](skills/service-mesh/SKILL.md) | Istio, Linkerd, network policies |
| 25 | [developer-experience](skills/developer-experience/SKILL.md) | Local dev, tooling, onboarding |
| 26 | [disaster-recovery](skills/disaster-recovery/SKILL.md) | Backups, failover, business continuity |
| 27 | [identity-access](skills/identity-access/SKILL.md) | IAM, SSO, RBAC, OAuth/OIDC |
| 28 | [advanced-observability](skills/advanced-observability/SKILL.md) | Distributed tracing, SLOs, error budgets |
| 29 | [message-queues-events](skills/message-queues-events/SKILL.md) | Kafka, RabbitMQ, event-driven |
| 30 | [caching-strategies](skills/caching-strategies/SKILL.md) | Redis, Memcached, CDN caching |
| 31 | [search-infrastructure](skills/search-infrastructure/SKILL.md) | Elasticsearch, Algolia |
| 32 | [feature-flags-experimentation](skills/feature-flags-experimentation/SKILL.md) | Feature toggles, A/B testing |
| 33 | [mobile-devops](skills/mobile-devops/SKILL.md) | App stores, mobile CI/CD |
| 34 | [gaming-infrastructure](skills/gaming-infrastructure/SKILL.md) | Game servers, matchmaking |
| 35 | [media-streaming](skills/media-streaming/SKILL.md) | Video processing, live streaming |
| 36 | [ecommerce-payments](skills/ecommerce-payments/SKILL.md) | Payment processing, Stripe |
| 37 | [realtime-websocket](skills/realtime-websocket/SKILL.md) | WebSocket, presence, collaboration |
| 38 | [localization-i18n](skills/localization-i18n/SKILL.md) | Multi-language, regional deployment |
| 39 | [graphql-infrastructure](skills/graphql-infrastructure/SKILL.md) | GraphQL servers, federation |
| 40 | [serverless-architecture](skills/serverless-architecture/SKILL.md) | Lambda, Functions, patterns |
| 41 | [legacy-modernization](skills/legacy-modernization/SKILL.md) | Migration, strangler pattern |

### Commands

See [`commands/`](commands/) for full documentation. CLI scripts in [`scripts/`](scripts/).

| Command | CLI Script | Description |
|---------|------------|-------------|
| [deploy](commands/deploy.md) | ✅ `devops-deploy` | Deploy to any platform (K8s, Docker, ECS, Lambda) |
| [logs](commands/logs.md) | ✅ `devops-logs` | View logs from K8s, Docker, CloudWatch |
| [secrets-manage](commands/secrets-manage.md) | ✅ `devops-secrets-manage` | Manage secrets (Vault, AWS, K8s) |
| [cache-manage](commands/cache-manage.md) | ✅ `devops-cache-manage` | Redis/Memcached cache operations |
| [infrastructure-audit](commands/infrastructure-audit.md) | ✅ `devops-infrastructure-audit` | Audit Terraform, K8s, Docker configs |
| [security-scan](commands/security-scan.md) | ✅ `devops-security-scan` | Run security analysis (code, secrets, deps) |
| [configure-dns](commands/configure-dns.md) | ✅ `devops-configure-dns` | DNS record management (Cloudflare, Route53) |
| [create-pipeline](commands/create-pipeline.md) | ✅ `devops-create-pipeline` | Generate CI/CD pipeline configs |
| [db-migrate](commands/db-migrate.md) | ✅ `devops-db-migrate` | Database migration runner |
| [k8s-deploy](commands/k8s-deploy.md) | ✅ `devops-k8s-deploy` | Advanced Kubernetes deployment |

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
