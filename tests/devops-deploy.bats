#!/usr/bin/env bats
# Tests for devops-deploy script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "deploy: shows usage with --help flag" {
    run "$SCRIPTS_DIR/devops-deploy" --help
    assert_success
    assert_output_contains "Deploy - Unified deployment tool"
    assert_output_contains "Usage:"
}

@test "deploy: shows usage with -h flag" {
    run "$SCRIPTS_DIR/devops-deploy" -h
    assert_success
    assert_output_contains "Deploy - Unified deployment tool"
}

@test "deploy: lists deployment targets in help" {
    run "$SCRIPTS_DIR/devops-deploy" --help
    assert_success
    assert_output_contains "k8s/"
    assert_output_contains "docker/"
    assert_output_contains "compose"
    assert_output_contains "helm/"
    assert_output_contains "ecs/"
    assert_output_contains "lambda/"
}

@test "deploy: lists deployment options in help" {
    run "$SCRIPTS_DIR/devops-deploy" --help
    assert_success
    assert_output_contains "--env="
    assert_output_contains "--namespace="
    assert_output_contains "--tag="
    assert_output_contains "--strategy="
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
    assert_output_contains "--rollback"
}

@test "deploy: shows examples in help" {
    run "$SCRIPTS_DIR/devops-deploy" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops deploy k8s/myapp"
}

@test "deploy: lists environment variables in help" {
    run "$SCRIPTS_DIR/devops-deploy" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "ENVIRONMENT"
    assert_output_contains "NAMESPACE"
    assert_output_contains "IMAGE_TAG"
    assert_output_contains "KUBECONFIG"
}

@test "deploy: script is executable" {
    [[ -x "$SCRIPTS_DIR/devops-deploy" ]]
}

@test "deploy: uses bash with strict mode" {
    run head -10 "$SCRIPTS_DIR/devops-deploy"
    assert_output_contains "set -euo pipefail"
}

@test "deploy: accepts --dry-run flag" {
    # Create mock kubectl
    create_mock_script "kubectl" "cluster-info" 0

    run "$SCRIPTS_DIR/devops-deploy" --dry-run 2>&1 || true
    # Should not fail with "unknown option"
    assert_output_not_contains "unknown option"
}

@test "deploy: defaults ENVIRONMENT to staging" {
    run grep -E 'ENVIRONMENT=.*staging' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: defaults NAMESPACE to default" {
    run grep -E 'NAMESPACE=.*default' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: defaults IMAGE_TAG to latest" {
    run grep -E 'IMAGE_TAG=.*latest' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: supports rolling strategy" {
    run grep -E 'rolling' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: supports blue-green strategy" {
    run grep -E 'blue-green' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: supports canary strategy" {
    run grep -E 'canary' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: has preflight check function" {
    run grep -E '^preflight\(\)' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: checks for kubectl availability" {
    run grep -E 'command -v kubectl' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: checks for docker availability" {
    run grep -E 'command -v docker' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: checks for helm availability" {
    run grep -E 'command -v helm' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: checks for aws CLI availability" {
    run grep -E 'command -v aws' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: has kubernetes deployment function" {
    run grep -E '^deploy_kubernetes\(\)' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: has helm deployment function" {
    run grep -E '^deploy_helm\(\)' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}

@test "deploy: has docker deployment function" {
    run grep -E '^deploy_docker\(\)' "$SCRIPTS_DIR/devops-deploy"
    assert_success
}
