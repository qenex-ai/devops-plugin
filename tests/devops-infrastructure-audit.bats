#!/usr/bin/env bats
# Tests for devops-infrastructure-audit script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "infrastructure-audit: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops-infrastructure-audit" --help
    assert_success
    assert_output_contains "Infrastructure Audit"
    assert_output_contains "Usage:"
}

@test "infrastructure-audit: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops-infrastructure-audit" -h
    assert_success
    assert_output_contains "Infrastructure Audit"
}

@test "infrastructure-audit: lists scope options in help" {
    run "$SCRIPTS_DIR/devops-infrastructure-audit" --help
    assert_success
    assert_output_contains "all"
    assert_output_contains "security"
    assert_output_contains "cost"
    assert_output_contains "reliability"
}

@test "infrastructure-audit: lists format options in help" {
    run "$SCRIPTS_DIR/devops-infrastructure-audit" --help
    assert_success
    assert_output_contains "--format="
    assert_output_contains "cli"
    assert_output_contains "json"
    assert_output_contains "sarif"
    assert_output_contains "markdown"
}

@test "infrastructure-audit: shows examples in help" {
    run "$SCRIPTS_DIR/devops-infrastructure-audit" --help
    assert_success
    assert_output_contains "Examples:"
}

@test "infrastructure-audit: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops-infrastructure-audit" ]]
}

@test "infrastructure-audit: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_output_contains "set -euo pipefail"
}

@test "infrastructure-audit: has severity counters" {
    run grep -E '^(CRITICAL|HIGH|MEDIUM|LOW)=' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: has check_tools function" {
    run grep -E '^check_tools\(\)' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for checkov" {
    run grep -E 'command -v checkov' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for tfsec" {
    run grep -E 'command -v tfsec' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for trivy" {
    run grep -E 'command -v trivy' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for hadolint" {
    run grep -E 'command -v hadolint' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: has detect_infrastructure function" {
    run grep -E '^detect_infrastructure\(\)' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: detects Terraform files" {
    run grep -E '\.tf' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: detects Kubernetes manifests" {
    run grep -E 'k8s|kubernetes|manifests' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: detects Dockerfiles" {
    run grep -E 'Dockerfile' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: detects Helm charts" {
    run grep -E 'Chart\.yaml|charts' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: has Terraform scanning function" {
    run grep -E '^scan_terraform\(\)' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for hardcoded secrets" {
    run grep -E 'password|secret|api_key|access_key' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for overly permissive IAM" {
    run grep -E 'Action.*\*|Resource.*\*' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks for public access" {
    run grep -E 'publicly_accessible|0\.0\.0\.0/0' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: checks encryption settings" {
    run grep -E 'encrypted.*false' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}

@test "infrastructure-audit: runs in current directory by default" {
    cd "$TEST_TEMP_DIR"
    create_sample_terraform

    # Should complete without errors when no tools are installed
    run "$SCRIPTS_DIR/devops-infrastructure-audit" --dry-run 2>&1 || true
    assert_output_not_contains "unknown option"
}

@test "infrastructure-audit: accepts --output flag" {
    run grep -E '\-\-output=' "$SCRIPTS_DIR/devops-infrastructure-audit"
    assert_success
}
