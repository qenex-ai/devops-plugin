---
name: logs
description: View and analyze logs from various sources (Kubernetes, Docker, cloud services)
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
argument-hint: "<source> [options] - e.g., 'k8s/myapp', 'docker/api', 'cloudwatch --since=1h'"
---

# Logs Command

View, search, and analyze logs from Kubernetes, Docker, CloudWatch, and other sources.

## Pre-flight Tool Validation

```bash
check_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Kubernetes
check_tool kubectl && echo "✓ kubectl available" || echo "○ kubectl not found"
check_tool stern && echo "✓ stern available (multi-pod logs)" || echo "○ stern not found (brew install stern)"

# Docker
check_tool docker && echo "✓ docker available" || echo "○ docker not found"

# Cloud logging
check_tool aws && echo "✓ aws CLI available" || echo "○ aws CLI not found"
check_tool gcloud && echo "✓ gcloud available" || echo "○ gcloud not found"

# Log analysis
check_tool jq && echo "✓ jq available" || echo "○ jq not found"
```

## Log Sources

### Kubernetes Logs

```bash
# Single pod logs
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -c <container-name>  # Specific container
kubectl logs <pod-name> --previous  # Previous container instance

# Follow logs
kubectl logs -f <pod-name>

# All pods for deployment
kubectl logs -l app=myapp -n production --all-containers

# Multi-pod with stern (recommended)
stern myapp -n production --since 1h
stern "myapp-.*" -n production -o json | jq

# Logs with timestamps
kubectl logs <pod-name> --timestamps

# Last N lines
kubectl logs <pod-name> --tail=100
```

### Docker Logs

```bash
# Container logs
docker logs <container-id>
docker logs -f <container-id>  # Follow
docker logs --since 1h <container-id>  # Since time
docker logs --tail 100 <container-id>  # Last N lines

# Docker Compose
docker-compose logs
docker-compose logs -f myservice
docker-compose logs --tail=100 myservice

# With timestamps
docker logs -t <container-id>
```

### AWS CloudWatch

```bash
# List log groups
aws logs describe-log-groups --query 'logGroups[*].logGroupName'

# Get recent logs
aws logs filter-log-events \
  --log-group-name /aws/lambda/my-function \
  --start-time $(date -d '1 hour ago' +%s000) \
  --query 'events[*].message'

# Search logs
aws logs filter-log-events \
  --log-group-name /aws/lambda/my-function \
  --filter-pattern "ERROR"

# Live tail (requires aws logs tail)
aws logs tail /aws/lambda/my-function --follow
```

### GCP Cloud Logging

```bash
# Read logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=my-service" \
  --limit 100 \
  --format "value(textPayload)"

# Filter by severity
gcloud logging read "severity>=ERROR" --limit 50

# Live streaming
gcloud alpha logging tail "resource.type=cloud_run_revision"
```

## Workflow

1. **Detect log source** from arguments:
   - `k8s/<deployment>` - Kubernetes deployment
   - `docker/<container>` - Docker container
   - `cloudwatch/<log-group>` - AWS CloudWatch
   - `gcp/<service>` - GCP Cloud Logging

2. **Parse options**:
   - `--since=<duration>` - Time range (1h, 30m, 1d)
   - `--tail=<lines>` - Number of lines
   - `--follow` / `-f` - Stream logs
   - `--search=<pattern>` - Filter pattern
   - `--json` - JSON output

3. **Execute appropriate command**

4. **Format output**:
   - Colorize log levels
   - Parse JSON if detected
   - Highlight search terms

## Log Analysis

### Error Detection

```bash
# Find errors in Kubernetes
kubectl logs -l app=myapp --since=1h | grep -i "error\|exception\|fatal"

# Count errors by type
kubectl logs -l app=myapp --since=1h | \
  grep -oE "(Error|Exception|Fatal)[^:]*" | \
  sort | uniq -c | sort -rn

# Find stack traces
kubectl logs -l app=myapp | grep -A 20 "Traceback\|at.*Exception"
```

### Performance Analysis

```bash
# Find slow requests (assuming JSON logs with duration)
kubectl logs -l app=myapp | jq -r 'select(.duration_ms > 1000) | "\(.timestamp) \(.path) \(.duration_ms)ms"'

# Request rate
kubectl logs -l app=myapp --since=1h | \
  grep "HTTP" | \
  cut -d'T' -f1 | uniq -c

# Status code distribution
kubectl logs -l app=myapp | \
  grep -oE "status[\":]+ ?[0-9]{3}" | \
  grep -oE "[0-9]{3}" | \
  sort | uniq -c | sort -rn
```

### JSON Log Parsing

```bash
# Pretty print JSON logs
kubectl logs <pod> | jq -R 'try fromjson catch .'

# Extract specific fields
kubectl logs <pod> | jq -r 'select(.level == "error") | "\(.timestamp) \(.message)"'

# Filter by field
kubectl logs <pod> | jq -r 'select(.user_id == "123")'
```

## Output Formats

- Default: Colorized terminal output
- `--format=json` - Raw JSON
- `--format=csv` - CSV for analysis
- `--format=table` - Tabular format

## Examples

```bash
# View last hour of errors from production app
/logs k8s/myapp --since=1h --search=error

# Stream logs from all containers
/logs k8s/myapp -f

# Export logs to file
/logs k8s/myapp --since=24h > /tmp/logs.txt

# Analyze CloudWatch Lambda logs
/logs cloudwatch/aws/lambda/my-function --since=1h --format=json | jq '.events[].message'

# Find 5xx errors in nginx
/logs docker/nginx --search="HTTP/1.1\" 5"
```

## Tips

- Use `stern` for multi-pod Kubernetes log viewing
- Pipe to `jq` for JSON log analysis
- Use `--since` to limit data volume
- Set up log aggregation (ELK, Loki, Datadog) for production
- Configure structured logging in applications
