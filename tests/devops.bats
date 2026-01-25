#!/usr/bin/env bats
# Tests for devops main CLI script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "devops: shows usage when called without arguments" {
    run "$SCRIPTS_DIR/devops"
    assert_success
    assert_output_contains "DevOps CLI"
    assert_output_contains "Usage: devops <command>"
}

@test "devops: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops" -h
    assert_success
    assert_output_contains "DevOps CLI"
    assert_output_contains "Commands:"
}

@test "devops: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops" --help
    assert_success
    assert_output_contains "DevOps CLI"
    assert_output_contains "Commands:"
}

@test "devops: shows version with -v flag" {
    run "$SCRIPTS_DIR/devops" -v
    assert_success
    assert_output_contains "DevOps CLI v"
}

@test "devops: shows version with --version flag" {
    run "$SCRIPTS_DIR/devops" --version
    assert_success
    assert_output_contains "DevOps CLI v"
}

@test "devops: returns error for unknown command" {
    run "$SCRIPTS_DIR/devops" unknown-command
    assert_failure
    assert_output_contains "Unknown command: unknown-command"
}

@test "devops: lists all available commands in help" {
    run "$SCRIPTS_DIR/devops" --help
    assert_success
    assert_output_contains "deploy"
    assert_output_contains "security-scan"
    assert_output_contains "infrastructure-audit"
    assert_output_contains "cache-manage"
    assert_output_contains "logs"
    assert_output_contains "secrets-manage"
}

@test "devops: shows examples in help" {
    run "$SCRIPTS_DIR/devops" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops deploy production"
}

@test "devops: shows options in help" {
    run "$SCRIPTS_DIR/devops" --help
    assert_success
    assert_output_contains "--dry-run"
}

@test "devops: recognizes deploy command" {
    # This will fail because deploy needs more args, but it should not say "unknown command"
    run "$SCRIPTS_DIR/devops" deploy --help 2>&1 || true
    assert_output_not_contains "Unknown command: deploy"
}

@test "devops: recognizes infrastructure-audit command" {
    run "$SCRIPTS_DIR/devops" infrastructure-audit --help 2>&1 || true
    assert_output_not_contains "Unknown command: infrastructure-audit"
}

@test "devops: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops" ]]
}

@test "devops: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops"
    assert_output_contains "set -euo pipefail"
}
