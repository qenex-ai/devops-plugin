---
name: secrets-manage
description: Manage secrets across different secret managers (Vault, AWS Secrets Manager, etc.)
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
argument-hint: "<action> [path] - e.g., 'list', 'get db/password', 'rotate api-key'"
---

# Secrets Management Command

Securely manage secrets across HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, and Kubernetes Secrets.

## Pre-flight Tool Validation

```bash
check_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Vault
check_tool vault && echo "✓ vault CLI available" || echo "○ vault CLI not found"

# Cloud CLIs
check_tool aws && echo "✓ aws CLI available" || echo "○ aws CLI not found"
check_tool gcloud && echo "✓ gcloud available" || echo "○ gcloud not found"
check_tool az && echo "✓ az CLI available" || echo "○ az CLI not found"

# Kubernetes
check_tool kubectl && echo "✓ kubectl available" || echo "○ kubectl not found"

# Check auth status
vault status >/dev/null 2>&1 && echo "✓ Vault authenticated" || echo "○ Vault not authenticated"
```

## Actions

### list - List available secrets

```bash
# HashiCorp Vault
vault kv list secret/
vault kv list secret/myapp/

# AWS Secrets Manager
aws secretsmanager list-secrets --query 'SecretList[*].Name'

# GCP Secret Manager
gcloud secrets list --format="value(name)"

# Kubernetes Secrets
kubectl get secrets -n <namespace>
```

### get - Retrieve secret value

```bash
# Vault
vault kv get secret/myapp/database
vault kv get -field=password secret/myapp/database

# AWS Secrets Manager
aws secretsmanager get-secret-value --secret-id myapp/database --query SecretString --output text

# GCP Secret Manager
gcloud secrets versions access latest --secret=myapp-database

# Kubernetes (base64 decoded)
kubectl get secret myapp-secrets -o jsonpath='{.data.password}' | base64 -d
```

### set - Create or update secret

```bash
# Vault
vault kv put secret/myapp/database password="newpassword123"

# AWS Secrets Manager (create)
aws secretsmanager create-secret \
  --name myapp/database \
  --secret-string '{"password":"newpassword123"}'

# AWS Secrets Manager (update)
aws secretsmanager put-secret-value \
  --secret-id myapp/database \
  --secret-string '{"password":"newpassword123"}'

# GCP Secret Manager
echo -n "newpassword123" | gcloud secrets create myapp-database --data-file=-

# Kubernetes
kubectl create secret generic myapp-secrets \
  --from-literal=password=newpassword123 \
  --dry-run=client -o yaml | kubectl apply -f -
```

### rotate - Rotate secret value

```bash
# Generate new secret
NEW_SECRET=$(openssl rand -base64 32)

# Update in secrets manager
vault kv put secret/myapp/database password="$NEW_SECRET"

# Trigger application reload
kubectl rollout restart deployment/myapp
```

### sync - Sync secrets to Kubernetes

```bash
# Using External Secrets Operator
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: myapp-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: myapp-secrets
  data:
  - secretKey: database-password
    remoteRef:
      key: secret/myapp/database
      property: password
EOF
```

## Workflow

1. **Detect secrets backend** from environment or arguments:
   - `VAULT_ADDR` - HashiCorp Vault
   - `AWS_REGION` - AWS Secrets Manager
   - `GOOGLE_PROJECT` - GCP Secret Manager
   - Kubernetes context - Kubernetes Secrets

2. **Validate authentication**:
   - Check token/credentials validity
   - Verify permissions for requested operation

3. **Execute operation** with safety checks

4. **Audit logging**:
   - Log all secret access (not values)
   - Track who accessed what and when

## Safety Features

- **Never log secret values** - Only log metadata
- **Mask in output** - Redact sensitive values in terminal
- **Require confirmation** - Confirm before overwriting
- **Audit trail** - All operations logged
- **Expiration warnings** - Alert on expiring secrets

## Secret Rotation Workflow

```bash
# 1. Generate new secret
NEW_DB_PASSWORD=$(openssl rand -base64 24)

# 2. Update in database (if applicable)
# This step varies by database type

# 3. Update secret manager
vault kv put secret/myapp/database password="$NEW_DB_PASSWORD"

# 4. Trigger application restart
kubectl rollout restart deployment/myapp -n production

# 5. Verify application health
kubectl rollout status deployment/myapp -n production

# 6. (Optional) Invalidate old secret after grace period
```

## Examples

```bash
# List all secrets for an app
/secrets-manage list myapp/

# Get a specific secret (value masked by default)
/secrets-manage get myapp/database

# Set a new secret
/secrets-manage set myapp/api-key --value="sk_live_xxx"

# Rotate database password
/secrets-manage rotate myapp/database --type=postgres

# Sync all secrets to Kubernetes
/secrets-manage sync --namespace=production
```

## Best Practices

| Practice | Description |
|----------|-------------|
| Least privilege | Grant minimal access to secrets |
| Rotation | Rotate secrets regularly (90 days) |
| Audit | Enable audit logging |
| Encryption | Encrypt at rest and in transit |
| Namespacing | Organize secrets by environment/app |
| Expiration | Set TTL on secrets |

## Integration with CI/CD

```yaml
# GitHub Actions example
- name: Get secrets from Vault
  uses: hashicorp/vault-action@v2
  with:
    url: ${{ secrets.VAULT_ADDR }}
    token: ${{ secrets.VAULT_TOKEN }}
    secrets: |
      secret/data/myapp/database password | DB_PASSWORD

- name: Deploy with secrets
  run: |
    kubectl create secret generic myapp-secrets \
      --from-literal=db-password=$DB_PASSWORD \
      --dry-run=client -o yaml | kubectl apply -f -
```

## Tips

- Never commit secrets to version control
- Use environment-specific secret paths
- Implement secret rotation automation
- Monitor for secret exposure in logs
- Use dynamic secrets where possible (Vault)
