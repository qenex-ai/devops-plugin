# Dependencies

This document lists all external tools and dependencies required by the DevOps Plugin.

## Required Tools by Command

### Core Tools

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| bash | 4.0+ | All scripts | Pre-installed on most systems |
| coreutils | - | All scripts | Pre-installed on most systems |

### Container & Orchestration

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| kubectl | 1.20+ | `deploy`, `logs`, `secrets-manage` | [Install kubectl](https://kubernetes.io/docs/tasks/tools/) |
| helm | 3.0+ | `deploy` (Helm deployments) | `brew install helm` or [Install Helm](https://helm.sh/docs/intro/install/) |
| docker | 20.10+ | `deploy`, `logs` | [Install Docker](https://docs.docker.com/get-docker/) |
| docker-compose | 2.0+ | `deploy` (Compose deployments) | Included with Docker Desktop |

### Cloud CLIs

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| aws | 2.0+ | `deploy` (ECS/Lambda), `logs`, `secrets-manage` | `brew install awscli` or [Install AWS CLI](https://aws.amazon.com/cli/) |
| gcloud | - | `secrets-manage` (GCP secrets) | [Install gcloud](https://cloud.google.com/sdk/docs/install) |
| az | - | Azure deployments | [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) |

### Security & Scanning

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| checkov | 2.0+ | `infrastructure-audit` | `pip install checkov` |
| tfsec | 1.0+ | `infrastructure-audit` (Terraform) | `brew install tfsec` |
| trivy | 0.40+ | `infrastructure-audit` (containers) | `brew install trivy` |
| hadolint | - | `infrastructure-audit` (Dockerfiles) | `brew install hadolint` |
| semgrep | - | `security-scan` | `pip install semgrep` |
| gitleaks | - | `security-scan` (secrets) | `brew install gitleaks` |
| snyk | - | `security-scan` (dependencies) | `npm install -g snyk` |

### Secrets Management

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| vault | 1.10+ | `secrets-manage` (HashiCorp Vault) | `brew install vault` |
| sops | - | `secrets-manage` (encrypted files) | `brew install sops` |

### Caching

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| redis-cli | 6.0+ | `cache-manage` (Redis) | `brew install redis` |
| curl | - | `cache-manage` (CDN APIs) | Pre-installed on most systems |

### Infrastructure as Code

| Tool | Version | Required For | Installation |
|------|---------|--------------|--------------|
| terraform | 1.0+ | `infrastructure-audit` | `brew install terraform` |
| pulumi | - | IaC deployments | [Install Pulumi](https://www.pulumi.com/docs/get-started/install/) |

## Development Dependencies

These tools are required for developing and testing the plugin itself:

| Tool | Version | Purpose | Installation |
|------|---------|---------|--------------|
| bats-core | 1.10+ | Bash testing | `brew install bats-core` |
| shellcheck | 0.9+ | Bash linting | `brew install shellcheck` |

### Installing bats-core with helpers

```bash
# macOS
brew install bats-core

# Linux (via npm)
npm install -g bats

# From source
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local
```

### Installing bats helper libraries

```bash
# Clone helper libraries for testing
git clone https://github.com/bats-core/bats-support.git tests/test_helper/bats-support
git clone https://github.com/bats-core/bats-assert.git tests/test_helper/bats-assert
git clone https://github.com/bats-core/bats-file.git tests/test_helper/bats-file
```

## Quick Install (All Dependencies)

### macOS (Homebrew)

```bash
# Core tools
brew install kubectl helm docker awscli

# Security tools
brew install tfsec trivy hadolint gitleaks
pip install checkov semgrep

# Secrets management
brew install vault sops

# Caching
brew install redis

# Development
brew install bats-core shellcheck
```

### Ubuntu/Debian

```bash
# Update package list
sudo apt-get update

# Core tools
sudo apt-get install -y curl docker.io

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Security tools
pip install checkov semgrep
sudo apt-get install -y trivy

# Development
sudo apt-get install -y shellcheck
npm install -g bats
```

## Minimum Requirements

For basic functionality, you need at least:

1. **bash 4.0+** - Script execution
2. **One container tool** - Either `kubectl`, `docker`, or `helm`
3. **One cloud CLI** - Either `aws`, `gcloud`, or `az` (depending on your cloud)

The plugin will gracefully degrade if optional tools are not installed, showing warnings but continuing with available functionality.

## Verifying Installation

Run the following to check which tools are available:

```bash
# Quick check
for cmd in kubectl helm docker aws gcloud vault redis-cli checkov tfsec trivy hadolint; do
  if command -v $cmd &>/dev/null; then
    echo "✓ $cmd"
  else
    echo "✗ $cmd (not installed)"
  fi
done
```

Or use the built-in preflight check:

```bash
devops deploy --dry-run
devops infrastructure-audit --dry-run
```
