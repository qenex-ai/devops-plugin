#!/usr/bin/env bash
# Common test helper functions for bats tests

# Get the directory containing the scripts
SCRIPTS_DIR="$(cd "$(dirname "${BATS_TEST_DIRNAME}")/scripts" && pwd)"
FIXTURES_DIR="${BATS_TEST_DIRNAME}/fixtures"

# Export for use in tests
export SCRIPTS_DIR
export FIXTURES_DIR

# Setup function to create temporary test environment
setup_test_environment() {
    # Create a temporary directory for test files
    TEST_TEMP_DIR="$(mktemp -d)"
    export TEST_TEMP_DIR
    cd "$TEST_TEMP_DIR" || exit 1
}

# Teardown function to clean up
teardown_test_environment() {
    if [[ -n "${TEST_TEMP_DIR:-}" && -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# Mock a command by creating a function that overrides it
mock_command() {
    local cmd="$1"
    local output="${2:-}"
    local exit_code="${3:-0}"

    eval "${cmd}() { echo '${output}'; return ${exit_code}; }"
    export -f "${cmd}"
}

# Create a mock command script
create_mock_script() {
    local cmd="$1"
    local output="${2:-}"
    local exit_code="${3:-0}"

    local mock_dir="${TEST_TEMP_DIR}/mock_bin"
    mkdir -p "$mock_dir"

    cat > "${mock_dir}/${cmd}" <<EOF
#!/usr/bin/env bash
echo "${output}"
exit ${exit_code}
EOF
    chmod +x "${mock_dir}/${cmd}"

    export PATH="${mock_dir}:$PATH"
}

# Assert that output contains a substring
assert_output_contains() {
    local expected="$1"
    if [[ "$output" != *"$expected"* ]]; then
        echo "Expected output to contain: $expected"
        echo "Actual output: $output"
        return 1
    fi
}

# Assert that output does not contain a substring
assert_output_not_contains() {
    local unexpected="$1"
    if [[ "$output" == *"$unexpected"* ]]; then
        echo "Expected output NOT to contain: $unexpected"
        echo "Actual output: $output"
        return 1
    fi
}

# Assert exit status
assert_success() {
    if [[ "$status" -ne 0 ]]; then
        echo "Expected success (exit 0), got exit $status"
        echo "Output: $output"
        return 1
    fi
}

# Assert failure
assert_failure() {
    if [[ "$status" -eq 0 ]]; then
        echo "Expected failure (exit non-zero), got exit 0"
        echo "Output: $output"
        return 1
    fi
}

# Assert specific exit code
assert_exit_code() {
    local expected="$1"
    if [[ "$status" -ne "$expected" ]]; then
        echo "Expected exit code $expected, got $status"
        echo "Output: $output"
        return 1
    fi
}

# Skip test if command is not available
skip_if_no_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        skip "$cmd not available"
    fi
}

# Create a sample Terraform file for testing
create_sample_terraform() {
    cat > "${TEST_TEMP_DIR}/main.tf" <<'EOF'
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "example"
  }
}
EOF
}

# Create a sample Dockerfile for testing
create_sample_dockerfile() {
    cat > "${TEST_TEMP_DIR}/Dockerfile" <<'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF
}

# Create sample Kubernetes manifests
create_sample_k8s_manifests() {
    mkdir -p "${TEST_TEMP_DIR}/k8s"
    cat > "${TEST_TEMP_DIR}/k8s/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 8080
EOF
}

# Create sample docker-compose file
create_sample_docker_compose() {
    cat > "${TEST_TEMP_DIR}/docker-compose.yml" <<'EOF'
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
  redis:
    image: redis:alpine
EOF
}
