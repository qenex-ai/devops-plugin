---
name: infrastructure-audit
description: Audit infrastructure configurations for security, cost, and best practices
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
argument-hint: "[scope] [options] - e.g., 'all', 'security', 'cost --format=json'"
---

# Infrastructure Audit Command

Comprehensive audit of infrastructure configurations covering security, cost optimization, reliability, and best practices.

## Pre-flight Tool Validation

```bash
# Check available tools
check_tool() {
    command -v "$1" >/dev/null 2>&1
}

# IaC scanning tools
check_tool checkov && echo "✓ checkov available" || echo "○ checkov not found (pip install checkov)"
check_tool tfsec && echo "✓ tfsec available" || echo "○ tfsec not found (brew install tfsec)"
check_tool trivy && echo "✓ trivy available" || echo "○ trivy not found (brew install trivy)"

# Cloud CLIs for live auditing
check_tool aws && echo "✓ aws CLI available" || echo "○ aws CLI not found"
check_tool gcloud && echo "✓ gcloud available" || echo "○ gcloud not found"
check_tool az && echo "✓ az CLI available" || echo "○ az CLI not found"

# Kubernetes tools
check_tool kubectl && echo "✓ kubectl available" || echo "○ kubectl not found"
check_tool kube-bench && echo "✓ kube-bench available" || echo "○ kube-bench not found"
```

## Workflow

1. **Detect infrastructure type**:
   - Terraform: `*.tf` files, `terraform/` directory
   - CloudFormation: `*.yaml` with `AWSTemplateFormatVersion`
   - Kubernetes: `k8s/`, `kubernetes/`, `*.yaml` with `apiVersion`
   - Docker: `Dockerfile`, `docker-compose.yml`
   - Helm: `Chart.yaml`, `charts/` directory

2. **Run security audit**:
   - IaC security scanning (checkov, tfsec, trivy)
   - Secret detection
   - Misconfiguration detection
   - Compliance checks (CIS, SOC2, HIPAA, PCI-DSS)

3. **Run cost analysis**:
   - Resource sizing recommendations
   - Unused resources detection
   - Reserved instance recommendations
   - Spot/preemptible opportunities

4. **Check reliability**:
   - High availability configurations
   - Backup configurations
   - Disaster recovery readiness
   - Auto-scaling configurations

5. **Generate report**:
   - Summary with risk scores
   - Detailed findings with remediation
   - Priority ranking (critical, high, medium, low)

## Audit Categories

### Security Audit

```bash
# Terraform security scan
checkov -d . --framework terraform --output cli
tfsec . --format lovely

# CloudFormation scan
checkov -d . --framework cloudformation

# Kubernetes manifest scan
checkov -d k8s/ --framework kubernetes
trivy config k8s/

# Docker security
trivy config Dockerfile
hadolint Dockerfile

# Helm chart scan
checkov -d charts/ --framework helm
```

### Cost Analysis

```bash
# AWS cost analysis
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '30 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics "BlendedCost" "UnblendedCost" "UsageQuantity"

# Find unused resources
aws ec2 describe-volumes --filters "Name=status,Values=available"
aws ec2 describe-addresses --filters "Name=association-id,Values="
aws elb describe-load-balancers  # Check for LBs with no targets

# GCP cost recommendations
gcloud recommender recommendations list --recommender=google.compute.instance.MachineTypeRecommender
```

### Reliability Checks

```yaml
# Kubernetes reliability checklist
checks:
  - name: Replica count
    query: "spec.replicas >= 2 for production deployments"
    severity: high

  - name: Resource limits
    query: "resources.limits defined for all containers"
    severity: medium

  - name: Liveness probes
    query: "livenessProbe defined for all containers"
    severity: high

  - name: PodDisruptionBudget
    query: "PDB exists for critical deployments"
    severity: medium

  - name: Anti-affinity
    query: "podAntiAffinity configured for HA"
    severity: medium
```

## Output Formats

- `--format=cli` - Human-readable terminal output (default)
- `--format=json` - JSON for CI/CD integration
- `--format=sarif` - SARIF for GitHub Security
- `--format=html` - HTML report for sharing
- `--format=markdown` - Markdown for documentation

## Common Findings

### Critical
- Publicly exposed databases
- Hardcoded secrets
- Unencrypted storage
- Root/admin access without MFA

### High
- Missing network segmentation
- Overly permissive IAM policies
- Missing encryption in transit
- No backup configuration

### Medium
- Missing resource tags
- Oversized instances
- No auto-scaling configured
- Missing monitoring/alerting

### Low
- Deprecated API versions
- Suboptimal instance types
- Missing cost allocation tags

## Example Output

```
Infrastructure Audit Report
===========================
Scan completed: 2024-01-15 10:30:00

Summary:
  Critical: 2
  High: 5
  Medium: 12
  Low: 8

Critical Findings:
------------------
[CKV_AWS_23] S3 bucket has public read access
  File: terraform/storage.tf:15
  Resource: aws_s3_bucket.user_uploads
  Fix: Add "block_public_access" configuration

[CKV_K8S_40] Secret data stored in plain text
  File: k8s/secrets.yaml:10
  Resource: Secret/database-credentials
  Fix: Use external secrets manager (Vault, AWS Secrets Manager)

High Findings:
--------------
[CKV_AWS_19] EBS volume not encrypted
  File: terraform/compute.tf:45
  Resource: aws_ebs_volume.data
  Fix: Add "encrypted = true"

Cost Optimization:
------------------
- 3 instances could be downsized (estimated savings: $150/month)
- 2 unused EBS volumes detected (5GB total)
- Consider reserved instances for stable workloads

Reliability:
------------
- 2 deployments lack PodDisruptionBudgets
- Database missing multi-AZ configuration
- No disaster recovery runbook found
```

## CI/CD Integration

```yaml
# GitHub Actions
- name: Infrastructure Audit
  run: |
    checkov -d . --output sarif --output-file-path results.sarif

- name: Upload SARIF
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: results.sarif
```

## Tips

- Run audits regularly (weekly for security, monthly for cost)
- Set up automated audits in CI/CD pipeline
- Create exceptions file for known/accepted risks
- Track audit score trends over time
- Share reports with stakeholders
