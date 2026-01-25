#!/usr/bin/env bats
# Tests for devops-logs script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "logs: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops-logs" --help
    assert_success
    assert_output_contains "Logs - View and analyze logs"
    assert_output_contains "Usage:"
}

@test "logs: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops-logs" -h
    assert_success
    assert_output_contains "Logs - View and analyze logs"
}

@test "logs: lists log sources in help" {
    run "$SCRIPTS_DIR/devops-logs" --help
    assert_success
    assert_output_contains "k8s/"
    assert_output_contains "docker/"
    assert_output_contains "cloudwatch/"
    assert_output_contains "file/"
}

@test "logs: lists options in help" {
    run "$SCRIPTS_DIR/devops-logs" --help
    assert_success
    assert_output_contains "--since="
    assert_output_contains "--tail="
    assert_output_contains "--follow"
    assert_output_contains "--search="
    assert_output_contains "--format="
    assert_output_contains "--namespace="
    assert_output_contains "--all-containers"
}

@test "logs: shows examples in help" {
    run "$SCRIPTS_DIR/devops-logs" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops logs k8s/myapp"
}

@test "logs: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops-logs" ]]
}

@test "logs: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops-logs"
    assert_output_contains "set -euo pipefail"
}

@test "logs: defaults SINCE to 1h" {
    run grep -E 'SINCE=.*1h' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: defaults TAIL to 100" {
    run grep -E 'TAIL=.*100' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: defaults FOLLOW to false" {
    run grep -E 'FOLLOW=.*false' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: defaults FORMAT to text" {
    run grep -E 'FORMAT=.*text' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: has check_tools function" {
    run grep -E '^check_tools\(\)' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: checks for kubectl for k8s source" {
    run grep -E 'command -v kubectl' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: checks for docker for docker source" {
    run grep -E 'command -v docker' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: checks for aws CLI for cloudwatch source" {
    run grep -E 'command -v aws' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: has logs_kubernetes function" {
    run grep -E '^logs_kubernetes\(\)' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: has logs_docker function" {
    run grep -E '^logs_docker\(\)' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: supports --follow or -f flag" {
    run grep -E '\-f\|--follow|--follow\|-f' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: supports search/filter functionality" {
    run grep -E 'SEARCH|--search' "$SCRIPTS_DIR/devops-logs"
    assert_success
}

@test "logs: supports all-containers option" {
    run grep -E '\-\-all-containers|ALL_CONTAINERS' "$SCRIPTS_DIR/devops-logs"
    assert_success
}
