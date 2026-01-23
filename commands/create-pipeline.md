---
name: create-pipeline
description: Generate CI/CD pipeline configuration for GitHub Actions, GitLab CI, or Jenkins
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash
argument-hint: "[platform] [options] - e.g., 'github', 'gitlab --with-deploy', 'jenkins'"
---

# Create Pipeline Command

Generate CI/CD pipeline configurations based on project structure and requirements.

## Workflow

1. **Detect project type** by analyzing:
   - Package files (package.json, requirements.txt, go.mod, Cargo.toml)
   - Build configurations
   - Test configurations
   - Docker/Kubernetes files

2. **Determine target platform** from arguments:
   - `github` - GitHub Actions (default)
   - `gitlab` - GitLab CI/CD
   - `jenkins` - Jenkinsfile

3. **Generate pipeline** with stages:
   - Build
   - Test (unit, integration, e2e)
   - Security scan
   - Deploy (if `--with-deploy` specified)

4. **Write configuration file** to appropriate location

## Options

- `--with-deploy` - Include deployment stages
- `--with-security` - Include security scanning
- `--environments=staging,production` - Specify deployment environments

## Tips

- Review generated pipeline before committing
- Customize caching strategies for faster builds
- Add appropriate secrets to repository settings
