---
name: configure-dns
description: Help configure DNS records for domains, including A, CNAME, MX, and TXT records
allowed-tools:
  - Bash
  - Read
  - Write
argument-hint: "<domain> [record-type] - e.g., 'example.com A', 'example.com MX'"
---

# Configure DNS Command

Guide DNS configuration for domains with validation and best practices.

## Workflow

1. **Parse domain and record type** from arguments
2. **Analyze current DNS configuration** using dig
3. **Provide configuration recommendations** based on use case
4. **Generate DNS record templates** for common providers
5. **Validate DNS propagation** after changes

## Supported Record Types

- A/AAAA - IP address mapping
- CNAME - Domain aliases
- MX - Email server configuration
- TXT - SPF, DKIM, DMARC, verification
- NS - Nameserver delegation
- CAA - Certificate authority authorization

## Common Configurations

### Web Application
```
example.com.     A      <server-ip>
www.example.com. CNAME  example.com.
```

### Email (Google Workspace)
```
example.com.     MX     1 aspmx.l.google.com.
example.com.     TXT    "v=spf1 include:_spf.google.com ~all"
```

## Validation Commands

```bash
# Check A record
dig example.com A +short

# Check propagation
dig @8.8.8.8 example.com A +short
dig @1.1.1.1 example.com A +short
```
