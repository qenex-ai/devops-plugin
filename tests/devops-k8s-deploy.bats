#!/usr/bin/env bats
# Tests for devops-k8s-deploy script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "k8s-deploy: shows usage with --help flag" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "Kubernetes Deploy - Advanced Kubernetes deployment"
    assert_output_contains "Usage:"
}

@test "k8s-deploy: shows usage with -h flag" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" -h
    assert_success
    assert_output_contains "Kubernetes Deploy"
}

@test "k8s-deploy: lists actions in help" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "apply"
    assert_output_contains "status"
    assert_output_contains "rollout"
    assert_output_contains "scale"
    assert_output_contains "restart"
    assert_output_contains "diff"
    assert_output_contains "logs"
    assert_output_contains "exec"
}

@test "k8s-deploy: lists options in help" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "--namespace="
    assert_output_contains "--context="
    assert_output_contains "--timeout="
    assert_output_contains "--strategy="
    assert_output_contains "--image="
    assert_output_contains "--tag="
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
}

@test "k8s-deploy: shows examples in help" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops k8s-deploy"
}

@test "k8s-deploy: lists environment variables in help" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "NAMESPACE"
    assert_output_contains "KUBECONFIG"
    assert_output_contains "KUBECONTEXT"
}

@test "k8s-deploy: script is executable" {
    [ -x "${SCRIPTS_DIR}/devops-k8s-deploy" ]
}

@test "k8s-deploy: uses bash with strict mode" {
    head -10 "${SCRIPTS_DIR}/devops-k8s-deploy" | grep -q "set -euo pipefail"
}

@test "k8s-deploy: defaults namespace to default" {
    grep -q 'NAMESPACE.*default' "${SCRIPTS_DIR}/devops-k8s-deploy"
}

@test "k8s-deploy: defaults timeout to 300" {
    grep -q 'TIMEOUT=300' "${SCRIPTS_DIR}/devops-k8s-deploy"
}

@test "k8s-deploy: defaults strategy to rolling" {
    grep -q 'STRATEGY.*rolling' "${SCRIPTS_DIR}/devops-k8s-deploy"
}

@test "k8s-deploy: has check_prereqs function" {
    grep -q "check_prereqs()" "${SCRIPTS_DIR}/devops-k8s-deploy"
}

@test "k8s-deploy: supports rolling strategy" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "rolling"
}

@test "k8s-deploy: supports recreate strategy" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "recreate"
}

@test "k8s-deploy: supports blue-green strategy" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "blue-green"
}

@test "k8s-deploy: supports replicas override" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "--replicas="
}

@test "k8s-deploy: supports server-dry-run" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "--server-dry-run"
}

@test "k8s-deploy: supports wait option" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "--wait"
}

@test "k8s-deploy: supports rollout undo" {
    run "${SCRIPTS_DIR}/devops-k8s-deploy" --help
    assert_success
    assert_output_contains "--undo"
}
