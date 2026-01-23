---
name: security-scan
description: Run comprehensive security scans on code, dependencies, containers, and infrastructure
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
argument-hint: "[scope] [options] - e.g., 'all', 'dependencies', 'containers --severity=high'"
---

# Security Scan Command

Execute security scans across the codebase, dependencies, containers, and infrastructure configurations.

## Workflow

1. **Determine scan scope** from arguments:
   - `all` - Run all applicable scans
   - `code` or `sast` - Static application security testing
   - `dependencies` or `sca` - Software composition analysis
   - `containers` - Container image scanning
   - `iac` or `infrastructure` - Infrastructure as code scanning
   - `secrets` - Secret/credential detection

2. **Detect available scanning tools**:
   - Semgrep, CodeQL, Bandit (SAST)
   - npm audit, Snyk, OWASP Dependency-Check (SCA)
   - Trivy, Grype, Docker Scout (containers)
   - Checkov, tfsec, kube-bench (IaC)
   - gitleaks, trufflehog (secrets)

3. **Execute scans** using available tools:
   ```bash
   # Dependency scanning
   npm audit --json 2>/dev/null || true

   # Secret detection
   gitleaks detect --source . --report-format json 2>/dev/null || true

   # Container scanning
   trivy image myapp:latest --severity HIGH,CRITICAL 2>/dev/null || true

   # IaC scanning
   checkov -d . --quiet 2>/dev/null || true
   ```

4. **Aggregate and report findings**:
   - Group by severity (Critical, High, Medium, Low)
   - Deduplicate across tools
   - Provide remediation guidance
   - Generate summary report

## Severity Filtering

Use `--severity` to filter results:
- `--severity=critical` - Only critical findings
- `--severity=high` - Critical and high
- `--severity=medium` - Critical, high, and medium (default)
- `--severity=all` - All findings including low and info

## Output Formats

- Default: Human-readable summary
- `--json` - JSON output for CI/CD integration
- `--sarif` - SARIF format for GitHub Security

## Common Scans

### Quick Dependency Check
```bash
npm audit 2>/dev/null || yarn audit 2>/dev/null || pip-audit 2>/dev/null
```

### Secret Detection
```bash
gitleaks detect --source . -v
```

### Container Scan
```bash
trivy image --severity HIGH,CRITICAL $IMAGE_NAME
```

## Tips

- Run scans before merging PRs
- Add scans to CI/CD pipeline
- Keep scan tools updated for latest vulnerability databases
- Focus on critical and high severity first
- Track vulnerability trends over time
