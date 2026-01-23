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

## Workflow

1. **Identify deployment target** from arguments (production, staging, k8s, aws, gcp, azure, vercel, etc.)

2. **Pre-deployment validation**:
   - Check for uncommitted changes (warn if present)
   - Verify environment variables are configured
   - Run `/evaluate --quick` if project-context-manager is available
   - Validate deployment configuration files exist

3. **Determine deployment method** based on target and project structure:
   - Kubernetes: Look for `k8s/`, `kubernetes/`, or Helm charts
   - Docker: Look for `docker-compose.yml` or `Dockerfile`
   - Vercel/Netlify: Check for `vercel.json` or `netlify.toml`
   - AWS: Check for CDK, SAM, or Terraform configs
   - Custom: Check for deployment scripts in `scripts/` or `deploy/`

4. **Execute deployment**:
   - Show deployment plan first (unless `--force` specified)
   - Ask for confirmation for production deployments
   - Execute deployment commands
   - Monitor deployment progress

5. **Post-deployment verification**:
   - Run health checks
   - Verify service is responding
   - Report deployment status

## Safety Features

- **Dry-run mode**: Use `--dry-run` to see what would be deployed without executing
- **Production protection**: Always confirm before deploying to production
- **Rollback info**: Display rollback command after successful deployment
- **Timeout handling**: Set reasonable timeouts for deployment operations

## Example Deployments

```bash
# Kubernetes deployment
kubectl apply -f k8s/production/ --dry-run=client
kubectl apply -f k8s/production/
kubectl rollout status deployment/app

# Helm deployment
helm upgrade --install myapp ./chart -f values-prod.yaml --dry-run
helm upgrade --install myapp ./chart -f values-prod.yaml

# Docker Compose
docker-compose -f docker-compose.prod.yml up -d

# Vercel
vercel --prod

# AWS ECS
aws ecs update-service --cluster prod --service myapp --force-new-deployment
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

## Tips

- Always verify the current kubectl context before Kubernetes deployments
- Check cloud CLI authentication status before cloud deployments
- Use semantic versioning for container image tags
- Keep deployment logs for audit purposes
