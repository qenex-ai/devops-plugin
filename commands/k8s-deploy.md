---
name: k8s-deploy
description: Deploy applications to Kubernetes with Helm or kubectl
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
argument-hint: "[resource] [options] - e.g., 'app --namespace=prod', 'helm myapp --values=prod'"
---

# Kubernetes Deploy Command

Deploy and manage applications on Kubernetes clusters.

## Workflow

1. **Verify kubectl context** and cluster connectivity
2. **Detect deployment method** (Helm, Kustomize, raw manifests)
3. **Validate manifests** before applying
4. **Execute deployment** with rollout monitoring
5. **Verify deployment health** via pod status and logs

## Options

- `--namespace=<ns>` - Target namespace
- `--dry-run` - Show what would be deployed
- `--force` - Skip confirmation prompts
- `--watch` - Monitor rollout progress

## Commands

```bash
# Check context
kubectl config current-context

# Apply manifests
kubectl apply -f k8s/ --dry-run=client
kubectl apply -f k8s/

# Helm deployment
helm upgrade --install myapp ./chart -f values-prod.yaml

# Monitor rollout
kubectl rollout status deployment/myapp
```

## Rollback

```bash
# kubectl rollback
kubectl rollout undo deployment/myapp

# Helm rollback
helm rollback myapp 1
```
