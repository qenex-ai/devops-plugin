#!/usr/bin/env bats
# Tests for devops-security-scan script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "security-scan: shows usage with --help flag" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "Security Scan - Comprehensive security scanning"
    assert_output_contains "Usage:"
}

@test "security-scan: shows usage with -h flag" {
    run "${SCRIPTS_DIR}/devops-security-scan" -h
    assert_success
    assert_output_contains "Security Scan"
}

@test "security-scan: lists scopes in help" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "all"
    assert_output_contains "code"
    assert_output_contains "secrets"
    assert_output_contains "dependencies"
    assert_output_contains "container"
    assert_output_contains "iac"
}

@test "security-scan: lists options in help" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "--dir="
    assert_output_contains "--severity="
    assert_output_contains "--format="
    assert_output_contains "--output="
    assert_output_contains "--fail"
    assert_output_contains "--dry-run"
}

@test "security-scan: shows examples in help" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops security-scan"
}

@test "security-scan: lists environment variables in help" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "SCAN_DIR"
    assert_output_contains "OUTPUT_FORMAT"
}

@test "security-scan: script is executable" {
    [ -x "${SCRIPTS_DIR}/devops-security-scan" ]
}

@test "security-scan: uses bash with strict mode" {
    head -10 "${SCRIPTS_DIR}/devops-security-scan" | grep -q "set -euo pipefail"
}

@test "security-scan: lists supported tools" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "semgrep"
    assert_output_contains "gitleaks"
    assert_output_contains "trivy"
    assert_output_contains "checkov"
    assert_output_contains "tfsec"
}

@test "security-scan: lists code scanning tools" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "bandit"
}

@test "security-scan: lists secret detection tools" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "trufflehog"
}

@test "security-scan: lists dependency scanning tools" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "npm audit"
    assert_output_contains "pip-audit"
}

@test "security-scan: defaults severity to HIGH,CRITICAL" {
    grep -q 'SEVERITY.*HIGH,CRITICAL' "${SCRIPTS_DIR}/devops-security-scan"
}

@test "security-scan: defaults output format to text" {
    grep -q 'OUTPUT_FORMAT.*text' "${SCRIPTS_DIR}/devops-security-scan"
}

@test "security-scan: supports json output format" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "json"
}

@test "security-scan: supports sarif output format" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "sarif"
}

@test "security-scan: supports fix option" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "--fix"
}

@test "security-scan: supports baseline comparison" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "--baseline="
}

@test "security-scan: supports exclude pattern" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "--exclude="
}

@test "security-scan: has severity counters" {
    grep -q "CRITICAL=0" "${SCRIPTS_DIR}/devops-security-scan"
    grep -q "HIGH=0" "${SCRIPTS_DIR}/devops-security-scan"
}

@test "security-scan: supports container image scanning" {
    run "${SCRIPTS_DIR}/devops-security-scan" --help
    assert_success
    assert_output_contains "--image="
}
