#!/usr/bin/env bats
# Tests for devops-create-pipeline script

load 'test_helper/common'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "create-pipeline: shows usage with --help flag" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "Create Pipeline - Generate CI/CD pipeline"
    assert_output_contains "Usage:"
}

@test "create-pipeline: shows usage with -h flag" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" -h
    assert_success
    assert_output_contains "Create Pipeline"
}

@test "create-pipeline: lists platforms in help" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "github"
    assert_output_contains "gitlab"
    assert_output_contains "jenkins"
    assert_output_contains "azure"
    assert_output_contains "circleci"
    assert_output_contains "bitbucket"
}

@test "create-pipeline: lists options in help" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "--language="
    assert_output_contains "--output="
    assert_output_contains "--docker"
    assert_output_contains "--k8s"
    assert_output_contains "--security"
    assert_output_contains "--dry-run"
    assert_output_contains "--force"
}

@test "create-pipeline: shows examples in help" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "Examples:"
    assert_output_contains "devops create-pipeline"
}

@test "create-pipeline: lists environment variables in help" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "Environment Variables:"
    assert_output_contains "CI_PLATFORM"
    assert_output_contains "PROJECT_LANGUAGE"
}

@test "create-pipeline: script is executable" {
    [ -x "${SCRIPTS_DIR}/devops-create-pipeline" ]
}

@test "create-pipeline: uses bash with strict mode" {
    head -10 "${SCRIPTS_DIR}/devops-create-pipeline" | grep -q "set -euo pipefail"
}

@test "create-pipeline: lists supported languages" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "node"
    assert_output_contains "python"
    assert_output_contains "rust"
    assert_output_contains "go"
    assert_output_contains "java"
}

@test "create-pipeline: has detect_language function" {
    grep -q "detect_language()" "${SCRIPTS_DIR}/devops-create-pipeline"
}

@test "create-pipeline: detects node from package.json" {
    grep -A5 "detect_language()" "${SCRIPTS_DIR}/devops-create-pipeline" | grep -q "package.json"
}

@test "create-pipeline: detects python from requirements.txt" {
    grep -A10 "detect_language()" "${SCRIPTS_DIR}/devops-create-pipeline" | grep -q "requirements.txt"
}

@test "create-pipeline: detects rust from Cargo.toml" {
    grep -A15 "detect_language()" "${SCRIPTS_DIR}/devops-create-pipeline" | grep -q "Cargo.toml"
}

@test "create-pipeline: detects go from go.mod" {
    grep -A20 "detect_language()" "${SCRIPTS_DIR}/devops-create-pipeline" | grep -q "go.mod"
}

@test "create-pipeline: defaults platform to github" {
    grep -q 'PLATFORM.*github' "${SCRIPTS_DIR}/devops-create-pipeline"
}

@test "create-pipeline: supports coverage option" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "--coverage"
}

@test "create-pipeline: supports terraform option" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "--terraform"
}

@test "create-pipeline: supports notifications option" {
    run "${SCRIPTS_DIR}/devops-create-pipeline" --help
    assert_success
    assert_output_contains "--notifications"
}
