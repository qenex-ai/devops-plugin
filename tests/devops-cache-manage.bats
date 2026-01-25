#!/usr/bin/env bats
# Tests for devops-cache-manage script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "cache-manage: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops-cache-manage" --help
    assert_success
    assert_output_contains "Cache Management"
    assert_output_contains "Usage:"
}

@test "cache-manage: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops-cache-manage" -h
    assert_success
    assert_output_contains "Cache Management"
}

@test "cache-manage: lists cache actions in help" {
    run "$SCRIPTS_DIR/devops-cache-manage" --help
    assert_success
    assert_output_contains "flush"
    assert_output_contains "warm"
    assert_output_contains "inspect"
    assert_output_contains "stats"
    assert_output_contains "info"
}

@test "cache-manage: lists options in help" {
    run "$SCRIPTS_DIR/devops-cache-manage" --help
    assert_success
    assert_output_contains "--host="
    assert_output_contains "--port="
    assert_output_contains "--password="
    assert_output_contains "--batch="
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
}

@test "cache-manage: shows examples in help" {
    run "$SCRIPTS_DIR/devops-cache-manage" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops cache-manage stats"
}

@test "cache-manage: lists environment variables in help" {
    run "$SCRIPTS_DIR/devops-cache-manage" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "REDIS_HOST"
    assert_output_contains "REDIS_PORT"
    assert_output_contains "REDIS_PASSWORD"
}

@test "cache-manage: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops-cache-manage" ]]
}

@test "cache-manage: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops-cache-manage"
    assert_output_contains "set -euo pipefail"
}

@test "cache-manage: defaults REDIS_HOST to localhost" {
    run grep -E 'REDIS_HOST=.*localhost' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: defaults REDIS_PORT to 6379" {
    run grep -E 'REDIS_PORT=.*6379' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: defaults BATCH_SIZE to 100" {
    run grep -E 'BATCH_SIZE=.*100' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has redis_cmd function" {
    run grep -E '^redis_cmd\(\)' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has check_redis function" {
    run grep -E '^check_redis\(\)' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: checks for redis-cli" {
    run grep -E 'command -v redis-cli' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has cmd_stats function" {
    run grep -E '^cmd_stats\(\)' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has cmd_info function" {
    run grep -E '^cmd_info\(\)' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: supports password authentication" {
    run grep -E 'REDIS_PASSWORD|--password' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has flush functionality" {
    run grep -E 'flush' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: has inspect functionality" {
    run grep -E 'inspect' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: supports dry-run mode" {
    run grep -E 'DRY_RUN|dry-run' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: shows memory usage in stats" {
    run grep -E 'used_memory|Memory Used' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: shows key count in stats" {
    run grep -E 'DBSIZE|Total Keys' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}

@test "cache-manage: shows hit ratio in stats" {
    run grep -E 'hit_ratio|Hit Ratio' "$SCRIPTS_DIR/devops-cache-manage"
    assert_success
}
