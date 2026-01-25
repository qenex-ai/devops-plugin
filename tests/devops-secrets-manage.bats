#!/usr/bin/env bats
# Tests for devops-secrets-manage script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "secrets-manage: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "Secrets Management"
    assert_output_contains "Usage:"
}

@test "secrets-manage: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops-secrets-manage" -h
    assert_success
    assert_output_contains "Secrets Management"
}

@test "secrets-manage: lists secrets actions in help" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "list"
    assert_output_contains "get"
    assert_output_contains "set"
    assert_output_contains "delete"
    assert_output_contains "rotate"
    assert_output_contains "sync"
}

@test "secrets-manage: lists options in help" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "--backend="
    assert_output_contains "--namespace="
    assert_output_contains "--value="
    assert_output_contains "--show"
    assert_output_contains "--force"
}

@test "secrets-manage: lists backends in help" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "vault"
    assert_output_contains "aws"
    assert_output_contains "gcp"
    assert_output_contains "k8s"
}

@test "secrets-manage: shows examples in help" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops secrets-manage list"
    assert_output_contains "devops secrets-manage get"
    assert_output_contains "devops secrets-manage set"
}

@test "secrets-manage: lists environment variables in help" {
    run "$SCRIPTS_DIR/devops-secrets-manage" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "VAULT_ADDR"
    assert_output_contains "VAULT_TOKEN"
    assert_output_contains "AWS_REGION"
    assert_output_contains "GOOGLE_PROJECT"
}

@test "secrets-manage: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops-secrets-manage" ]]
}

@test "secrets-manage: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops-secrets-manage"
    assert_output_contains "set -euo pipefail"
}

@test "secrets-manage: has mask_value function" {
    run grep -E '^mask_value\(\)' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: has detect_backend function" {
    run grep -E '^detect_backend\(\)' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: has check_tools function" {
    run grep -E '^check_tools\(\)' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: checks for vault CLI" {
    run grep -E 'command -v vault' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: checks for aws CLI" {
    run grep -E 'command -v aws' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: checks for gcloud CLI" {
    run grep -E 'command -v gcloud' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: checks for kubectl" {
    run grep -E 'command -v kubectl' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: detects vault backend from VAULT_ADDR" {
    run grep -E 'VAULT_ADDR' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: detects AWS backend from AWS_REGION" {
    run grep -E 'AWS_REGION' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: detects GCP backend from GOOGLE_PROJECT" {
    run grep -E 'GOOGLE_PROJECT' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: masks sensitive values by default" {
    run grep -E 'mask_value|masked' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: supports --show flag to unmask" {
    run grep -E '\-\-show' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: supports sync to kubernetes" {
    run grep -E 'sync|Sync' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}

@test "secrets-manage: supports rotate action" {
    run grep -E 'rotate|Rotate' "$SCRIPTS_DIR/devops-secrets-manage"
    assert_success
}
