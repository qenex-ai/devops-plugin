---
name: deploy
description: Deploy application to any supported platform (Kubernetes, cloud providers, serverless, etc.)
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<target> [options] - e.g., 'production', 'staging --dry-run', 'k8s --namespace=prod'"
---

# Deploy Command

Deploy applications to various platforms with proper validation and rollback capabilities.

## Pre-flight Tool Validation

Before executing any deployment, verify required tools are available:

```bash
# Check tool availability based on deployment target
check_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Kubernetes deployments
if [[ "$target" == "k8s" ]] || [[ "$target" == "kubernetes" ]]; then
    check_tool kubectl || echo "ERROR: kubectl not found. Install: https://kubernetes.io/docs/tasks/tools/"
    check_tool helm || echo "WARNING: helm not found (optional). Install: https://helm.sh/docs/intro/install/"
fi

# Docker deployments
if [[ -f "docker-compose.yml" ]] || [[ -f "Dockerfile" ]]; then
    check_tool docker || echo "ERROR: docker not found. Install: https://docs.docker.com/get-docker/"
fi

# Cloud provider deployments
case "$target" in
    aws|ecs|lambda)
        check_tool aws || echo "ERROR: aws CLI not found. Install: https://aws.amazon.com/cli/"
        ;;
    gcp|gke|cloudrun)
        check_tool gcloud || echo "ERROR: gcloud CLI not found. Install: https://cloud.google.com/sdk/docs/install"
        ;;
    azure|aks)
        check_tool az || echo "ERROR: az CLI not found. Install: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        ;;
esac

# Serverless deployments
if [[ -f "serverless.yml" ]]; then
    check_tool serverless || check_tool sls || echo "ERROR: serverless not found. Install: npm install -g serverless"
fi

# Vercel/Netlify
if [[ -f "vercel.json" ]]; then
    check_tool vercel || echo "ERROR: vercel CLI not found. Install: npm install -g vercel"
fi
if [[ -f "netlify.toml" ]]; then
    check_tool netlify || echo "ERROR: netlify CLI not found. Install: npm install -g netlify-cli"
fi
```

## Workflow

1. **Validate prerequisites**:
   - Run tool availability checks (see above)
   - Verify authentication status for cloud providers
   - Check for uncommitted changes (warn if present)
   - Verify environment variables are configured

2. **Identify deployment target** from arguments (production, staging, k8s, aws, gcp, azure, vercel, etc.)

3. **Pre-deployment validation**:
   - Run `/evaluate --quick` if project-context-manager is available
   - Validate deployment configuration files exist
   - Check resource limits and quotas
   - Verify secrets are configured (not actual values)

4. **Determine deployment method** based on target and project structure:
   - Kubernetes: Look for `k8s/`, `kubernetes/`, or Helm charts
   - Docker: Look for `docker-compose.yml` or `Dockerfile`
   - Vercel/Netlify: Check for `vercel.json` or `netlify.toml`
   - AWS: Check for CDK, SAM, or Terraform configs
   - Custom: Check for deployment scripts in `scripts/` or `deploy/`

5. **Execute deployment**:
   - Show deployment plan first (unless `--force` specified)
   - Ask for confirmation for production deployments
   - Execute deployment commands
   - Monitor deployment progress

6. **Post-deployment verification**:
   - Run health checks
   - Verify service is responding
   - Check error rates in monitoring (if available)
   - Report deployment status

## Safety Features

- **Tool validation**: Verify all required CLIs are installed before starting
- **Auth checks**: Confirm cloud provider authentication is valid
- **Dry-run mode**: Use `--dry-run` to see what would be deployed without executing
- **Production protection**: Always confirm before deploying to production
- **Rollback info**: Display rollback command after successful deployment
- **Timeout handling**: Set reasonable timeouts for deployment operations

## Authentication Verification

```bash
# AWS - Check credentials
aws sts get-caller-identity >/dev/null 2>&1 || echo "ERROR: AWS credentials not configured"

# GCP - Check authentication
gcloud auth print-identity-token >/dev/null 2>&1 || echo "ERROR: GCP not authenticated. Run: gcloud auth login"

# Azure - Check login
az account show >/dev/null 2>&1 || echo "ERROR: Azure not logged in. Run: az login"

# Kubernetes - Check context
kubectl config current-context 2>/dev/null || echo "ERROR: No kubectl context configured"
```

## Example Deployments

```bash
# Kubernetes deployment with validation
kubectl config current-context  # Verify context
kubectl auth can-i create deployments  # Verify permissions
kubectl apply -f k8s/production/ --dry-run=client  # Dry run
kubectl apply -f k8s/production/
kubectl rollout status deployment/app --timeout=300s

# Helm deployment
helm repo update
helm upgrade --install myapp ./chart -f values-prod.yaml --dry-run
helm upgrade --install myapp ./chart -f values-prod.yaml --wait --timeout 5m
helm rollout status deployment/myapp

# Docker Compose
docker-compose -f docker-compose.prod.yml config  # Validate
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml ps

# Vercel
vercel --prod

# AWS ECS
aws ecs describe-services --cluster prod --services myapp  # Check current
aws ecs update-service --cluster prod --service myapp --force-new-deployment
aws ecs wait services-stable --cluster prod --services myapp

# AWS Lambda (SAM)
sam validate
sam build
sam deploy --no-confirm-changeset --no-fail-on-empty-changeset
```

## Configuration Detection

Look for deployment configurations in this order:
1. `deploy/` directory
2. `k8s/` or `kubernetes/` directory
3. `.github/workflows/deploy*.yml`
4. `docker-compose*.yml`
5. `vercel.json`, `netlify.toml`
6. `serverless.yml`
7. `terraform/` or `*.tf` files
8. `cdk.json` (AWS CDK)
9. `samconfig.toml` (AWS SAM)

## Rollback Commands

After successful deployment, display the rollback command:

```bash
# Kubernetes
kubectl rollout undo deployment/myapp

# Helm
helm rollback myapp [REVISION]

# AWS ECS
aws ecs update-service --cluster prod --service myapp --task-definition myapp:PREVIOUS_VERSION

# Vercel
vercel rollback
```

## Error Handling

If deployment fails:
1. Capture and display error logs
2. Check pod/container status for crash loops
3. Suggest common fixes based on error type
4. Provide rollback command if partial deployment occurred
5. Link to relevant documentation

## Tips

- Always verify the current kubectl context before Kubernetes deployments
- Check cloud CLI authentication status before cloud deployments
- Use semantic versioning for container image tags
- Keep deployment logs for audit purposes
- Set up deployment notifications (Slack, email, etc.)
- Use deployment windows for production changes
