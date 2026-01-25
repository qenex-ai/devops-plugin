#!/usr/bin/env bats
# Tests for devops-db-migrate script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "db-migrate: shows usage with --help flag" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "Database Migration - Run database migrations"
    assert_output_contains "Usage:"
}

@test "db-migrate: shows usage with -h flag" {
    run "${SCRIPTS_DIR}/devops-db-migrate" -h
    assert_success
    assert_output_contains "Database Migration"
}

@test "db-migrate: lists actions in help" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "status"
    assert_output_contains "up"
    assert_output_contains "down"
    assert_output_contains "create"
    assert_output_contains "validate"
    assert_output_contains "history"
}

@test "db-migrate: lists options in help" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "--database="
    assert_output_contains "--dir="
    assert_output_contains "--env="
    assert_output_contains "--backup"
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
    assert_output_contains "--timeout="
}

@test "db-migrate: shows examples in help" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops db-migrate"
}

@test "db-migrate: lists environment variables in help" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "DATABASE_URL"
    assert_output_contains "MIGRATION_DIR"
}

@test "db-migrate: script is executable" {
    [ -x "${SCRIPTS_DIR}/devops-db-migrate" ]
}

@test "db-migrate: uses bash with strict mode" {
    head -10 "${SCRIPTS_DIR}/devops-db-migrate" | grep -q "set -euo pipefail"
}

@test "db-migrate: lists supported migration tools" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "Django"
    assert_output_contains "Rails"
    assert_output_contains "Alembic"
    assert_output_contains "Flyway"
    assert_output_contains "Prisma"
    assert_output_contains "Knex"
}

@test "db-migrate: has detect_migration_tool function" {
    grep -q "detect_migration_tool\|detect_tool" "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: supports django migrations" {
    grep -q "manage.py" "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: supports rails migrations" {
    grep -q "rails" "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: supports alembic migrations" {
    grep -q "alembic" "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: defaults backup to true" {
    grep -q 'BACKUP=true' "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: defaults migration dir to migrations" {
    grep -q 'MIGRATION_DIR.*migrations' "${SCRIPTS_DIR}/devops-db-migrate"
}

@test "db-migrate: supports no-backup option" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "--no-backup"
}

@test "db-migrate: supports down --all for full rollback" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "down --all"
}

@test "db-migrate: supports golang-migrate" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "golang-migrate"
}

@test "db-migrate: supports diesel for rust" {
    run "${SCRIPTS_DIR}/devops-db-migrate" --help
    assert_success
    assert_output_contains "diesel"
}
