---
name: db-migrate
description: Run database migrations with safety checks and rollback support
allowed-tools:
  - Bash
  - Read
  - Glob
argument-hint: "[action] [options] - e.g., 'up', 'down 1', 'status', 'create add_users'"
---

# Database Migration Command

Safely execute database migrations with validation and rollback capabilities.

## Workflow

1. **Detect migration tool** in project:
   - Prisma, Drizzle, TypeORM (Node.js)
   - Alembic, Django migrations (Python)
   - golang-migrate (Go)
   - ActiveRecord (Ruby)

2. **Verify database connectivity** before migration
3. **Backup database** for production migrations (if configured)
4. **Execute migration** with appropriate flags
5. **Verify migration success** and report status

## Actions

- `up` - Run pending migrations
- `down [n]` - Rollback n migrations
- `status` - Show migration status
- `create <name>` - Create new migration file

## Safety Features

- Production migrations require confirmation
- Automatic backup before destructive migrations
- Transaction support where available
- Rollback command provided after each migration

## Example Commands

```bash
# Prisma
npx prisma migrate deploy

# Alembic
alembic upgrade head

# golang-migrate
migrate -database $DATABASE_URL -path migrations up
```
