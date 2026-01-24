---
name: cache-manage
description: Manage application caches (Redis, Memcached, CDN) - flush, warm, inspect
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
argument-hint: "<action> [target] - e.g., 'flush redis', 'warm api', 'inspect user:*'"
---

# Cache Management Command

Manage application caches across Redis, Memcached, and CDN layers with safety checks.

## Pre-flight Tool Validation

```bash
# Check tool availability
check_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Redis CLI
check_tool redis-cli && echo "✓ redis-cli available" || echo "○ redis-cli not found"

# AWS CLI for CloudFront/ElastiCache
check_tool aws && echo "✓ aws CLI available" || echo "○ aws CLI not found"

# GCP CLI for Cloud CDN/Memorystore
check_tool gcloud && echo "✓ gcloud CLI available" || echo "○ gcloud CLI not found"
```

## Actions

### flush - Clear cache entries

```bash
# Flush specific pattern (safe)
redis-cli --scan --pattern "user:*" | xargs -L 100 redis-cli DEL

# Flush entire database (dangerous - requires confirmation)
redis-cli FLUSHDB

# CloudFront invalidation
aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*"

# Cloudflare cache purge
curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
```

### warm - Pre-populate cache

```bash
# Warm popular endpoints
curl -s https://api.example.com/popular-items | jq -r '.items[].id' | \
  xargs -I {} curl -s https://api.example.com/items/{}

# Warm from sitemap
curl -s https://example.com/sitemap.xml | \
  grep -oP '(?<=<loc>)[^<]+' | \
  xargs -P 10 -I {} curl -s -o /dev/null {}
```

### inspect - View cache contents

```bash
# Redis key inspection
redis-cli KEYS "user:*" | head -20
redis-cli --scan --pattern "session:*" | wc -l
redis-cli INFO memory
redis-cli INFO stats

# Check specific key
redis-cli GET "user:123"
redis-cli TTL "user:123"
redis-cli TYPE "user:123"

# Memory analysis
redis-cli MEMORY USAGE "user:123"
redis-cli DEBUG OBJECT "user:123"
```

### stats - Cache statistics

```bash
# Redis stats
redis-cli INFO | grep -E "(hits|misses|memory|keys)"

# Calculate hit ratio
hits=$(redis-cli INFO stats | grep keyspace_hits | cut -d: -f2 | tr -d '\r')
misses=$(redis-cli INFO stats | grep keyspace_misses | cut -d: -f2 | tr -d '\r')
echo "Hit ratio: $(echo "scale=2; $hits / ($hits + $misses) * 100" | bc)%"

# Memory breakdown
redis-cli MEMORY STATS
```

## Workflow

1. **Identify cache type** from arguments or auto-detect:
   - Check for Redis connection (REDIS_URL, REDIS_HOST)
   - Check for Memcached connection
   - Check for CDN configuration

2. **Validate permissions**:
   - Check if operation requires elevated permissions
   - Confirm destructive operations (flush)

3. **Execute operation**:
   - Run with appropriate safety checks
   - Log all operations for audit

4. **Report results**:
   - Number of keys affected
   - Memory freed/used
   - Time taken

## Safety Features

- **Pattern validation**: Prevent accidental `KEYS *` on production
- **Confirmation prompts**: Require confirmation for destructive operations
- **Rate limiting**: Batch large operations to prevent Redis blocking
- **Dry-run mode**: Show what would be affected without executing

## Examples

```bash
# Safe pattern flush (preview first)
/cache-manage inspect "session:expired:*"
# Shows: Found 1,523 keys matching pattern
/cache-manage flush "session:expired:*"

# Full cache warm after deployment
/cache-manage warm --endpoints=/api/popular,/api/featured --concurrency=10

# Cache stats
/cache-manage stats redis
# Output:
# Memory used: 256MB
# Total keys: 45,231
# Hit ratio: 94.2%
# Evicted keys (24h): 1,203

# CDN invalidation
/cache-manage flush cdn --paths="/static/*,/api/v1/*"
```

## Common Patterns

### Session Management
```bash
# Clear expired sessions
redis-cli --scan --pattern "session:*" | while read key; do
  ttl=$(redis-cli TTL "$key")
  if [ "$ttl" -eq -1 ]; then
    redis-cli EXPIRE "$key" 86400  # Set 24h expiry
  fi
done
```

### Cache Debugging
```bash
# Find large keys
redis-cli --bigkeys

# Find keys without TTL
redis-cli --scan --pattern "*" | while read key; do
  ttl=$(redis-cli TTL "$key")
  if [ "$ttl" -eq -1 ]; then
    echo "$key has no TTL"
  fi
done | head -20

# Slow log analysis
redis-cli SLOWLOG GET 10
```

### Memory Optimization
```bash
# Identify memory hogs
redis-cli DEBUG OBJECT $(redis-cli --scan | head -100) 2>/dev/null | \
  sort -t: -k4 -rn | head -10

# Recommend memory policy
current_policy=$(redis-cli CONFIG GET maxmemory-policy | tail -1)
echo "Current policy: $current_policy"
echo "Recommended: allkeys-lru for cache, volatile-lru for mixed"
```

## Output Format

```
Cache Management Report
=======================
Action: flush
Target: user:session:*
Time: 2024-01-15 10:30:00

Results:
  Keys scanned: 50,000
  Keys deleted: 12,345
  Memory freed: 45.2 MB
  Duration: 2.3s

Warnings:
  - High key count, operation was batched
  - Consider setting TTL on new keys
```

## Tips

- Always use `--scan` instead of `KEYS` in production
- Batch large operations (100-1000 keys at a time)
- Monitor Redis during bulk operations
- Set up cache metrics in monitoring dashboard
- Use key prefixes for easier management
