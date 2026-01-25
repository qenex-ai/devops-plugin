#!/usr/bin/env bats
# Tests for devops-configure-dns script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "configure-dns: shows usage with --help flag" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "Configure DNS - Manage DNS records"
    assert_output_contains "Usage:"
}

@test "configure-dns: shows usage with -h flag" {
    run "${SCRIPTS_DIR}/devops-configure-dns" -h
    assert_success
    assert_output_contains "Configure DNS"
}

@test "configure-dns: lists actions in help" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "list"
    assert_output_contains "get"
    assert_output_contains "set"
    assert_output_contains "delete"
    assert_output_contains "check"
    assert_output_contains "export"
    assert_output_contains "import"
}

@test "configure-dns: lists options in help" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "--provider="
    assert_output_contains "--type="
    assert_output_contains "--value="
    assert_output_contains "--ttl="
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
}

@test "configure-dns: shows examples in help" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops configure-dns"
}

@test "configure-dns: lists environment variables in help" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "DNS_PROVIDER"
    assert_output_contains "CLOUDFLARE_API_TOKEN"
}

@test "configure-dns: script is executable" {
    [ -x "${SCRIPTS_DIR}/devops-configure-dns" ]
}

@test "configure-dns: uses bash with strict mode" {
    head -10 "${SCRIPTS_DIR}/devops-configure-dns" | grep -q "set -euo pipefail"
}

@test "configure-dns: lists supported providers" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "cloudflare"
    assert_output_contains "route53"
}

@test "configure-dns: lists record types" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "A, AAAA, CNAME, MX, TXT"
}

@test "configure-dns: has detect_provider function" {
    grep -q "detect_provider()" "${SCRIPTS_DIR}/devops-configure-dns"
}

@test "configure-dns: detects cloudflare from CLOUDFLARE_API_TOKEN" {
    grep -A5 "detect_provider()" "${SCRIPTS_DIR}/devops-configure-dns" | grep -q "CLOUDFLARE_API_TOKEN"
}

@test "configure-dns: detects route53 from AWS credentials" {
    grep -A10 "detect_provider()" "${SCRIPTS_DIR}/devops-configure-dns" | grep -q "AWS"
}

@test "configure-dns: defaults TTL to 300" {
    grep -q 'TTL.*300' "${SCRIPTS_DIR}/devops-configure-dns"
}

@test "configure-dns: supports proxied option for cloudflare" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "--proxied"
}

@test "configure-dns: has security note about credentials" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "Security Note:"
}

@test "configure-dns: supports priority for MX records" {
    run "${SCRIPTS_DIR}/devops-configure-dns" --help
    assert_success
    assert_output_contains "--priority="
}

@test "configure-dns: has cloudflare_api function" {
    grep -q "cloudflare_api()" "${SCRIPTS_DIR}/devops-configure-dns"
}
