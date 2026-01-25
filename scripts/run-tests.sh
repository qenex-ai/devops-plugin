#!/usr/bin/env bash
#
# Run tests locally for DevOps Plugin
# Usage: ./scripts/run-tests.sh [options]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
header() { echo -e "\n${BOLD}$*${NC}"; }

usage() {
    cat <<EOF
Run DevOps Plugin Tests

Usage: $0 [options]

Options:
  --lint        Run shellcheck linting only
  --test        Run bats tests only
  --all         Run all checks (default)
  --install     Install test dependencies
  -h, --help    Show this help

Examples:
  $0              # Run all checks
  $0 --lint       # Run shellcheck only
  $0 --test       # Run bats tests only
  $0 --install    # Install bats and shellcheck

EOF
}

# Check if shellcheck is installed
check_shellcheck() {
    if command -v shellcheck &>/dev/null; then
        success "shellcheck $(shellcheck --version | head -2 | tail -1)"
        return 0
    else
        warn "shellcheck not installed"
        return 1
    fi
}

# Check if bats is installed
check_bats() {
    if command -v bats &>/dev/null; then
        success "bats $(bats --version)"
        return 0
    else
        warn "bats not installed"
        return 1
    fi
}

# Install dependencies
install_deps() {
    header "Installing Test Dependencies"

    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        if ! command -v brew &>/dev/null; then
            error "Homebrew not found. Please install it first."
            exit 1
        fi

        info "Installing shellcheck..."
        brew install shellcheck || true

        info "Installing bats-core..."
        brew install bats-core || true

    elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        info "Installing shellcheck..."
        sudo apt-get update
        sudo apt-get install -y shellcheck

        info "Installing bats..."
        sudo apt-get install -y bats || {
            info "Installing bats from npm..."
            npm install -g bats
        }

    elif [[ -f /etc/redhat-release ]]; then
        # RHEL/CentOS/Fedora
        info "Installing shellcheck..."
        sudo dnf install -y ShellCheck || sudo yum install -y ShellCheck

        info "Installing bats via npm..."
        npm install -g bats

    else
        warn "Unknown OS. Please install shellcheck and bats manually."
        echo "  shellcheck: https://www.shellcheck.net/"
        echo "  bats: https://github.com/bats-core/bats-core"
        exit 1
    fi

    echo ""
    success "Dependencies installed!"
}

# Run shellcheck linting
run_lint() {
    header "Running Shellcheck"

    if ! check_shellcheck; then
        error "Please install shellcheck first: $0 --install"
        return 1
    fi

    local failed=0
    local checked=0

    for script in "$SCRIPT_DIR"/devops*; do
        if [[ -x "$script" ]]; then
            ((checked++))
            echo -n "Checking $(basename "$script")... "
            if shellcheck --severity=warning "$script" 2>/dev/null; then
                echo -e "${GREEN}OK${NC}"
            else
                echo -e "${RED}FAILED${NC}"
                ((failed++))
            fi
        fi
    done

    echo ""
    if [[ $failed -eq 0 ]]; then
        success "All $checked scripts passed shellcheck!"
        return 0
    else
        error "$failed of $checked scripts failed shellcheck"
        return 1
    fi
}

# Run bats tests
run_tests() {
    header "Running Bats Tests"

    if ! check_bats; then
        error "Please install bats first: $0 --install"
        return 1
    fi

    cd "$PROJECT_DIR"

    if [[ ! -d "tests" ]]; then
        error "Tests directory not found"
        return 1
    fi

    local test_files
    test_files=$(find tests -name "*.bats" -type f)

    if [[ -z "$test_files" ]]; then
        warn "No test files found"
        return 0
    fi

    echo ""
    bats tests/*.bats
}

# Run syntax check
run_syntax() {
    header "Running Syntax Check"

    local failed=0
    local checked=0

    for script in "$SCRIPT_DIR"/devops*; do
        if [[ -x "$script" ]]; then
            ((checked++))
            echo -n "Syntax check $(basename "$script")... "
            if bash -n "$script" 2>/dev/null; then
                echo -e "${GREEN}OK${NC}"
            else
                echo -e "${RED}FAILED${NC}"
                ((failed++))
            fi
        fi
    done

    echo ""
    if [[ $failed -eq 0 ]]; then
        success "All $checked scripts have valid syntax!"
        return 0
    else
        error "$failed of $checked scripts have syntax errors"
        return 1
    fi
}

# Main
main() {
    local run_all=true
    local run_lint_only=false
    local run_test_only=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --lint)
                run_lint_only=true
                run_all=false
                ;;
            --test)
                run_test_only=true
                run_all=false
                ;;
            --all)
                run_all=true
                ;;
            --install)
                install_deps
                exit 0
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done

    local exit_code=0

    if [[ "$run_all" == "true" ]]; then
        run_syntax || exit_code=1
        run_lint || exit_code=1
        run_tests || exit_code=1
    elif [[ "$run_lint_only" == "true" ]]; then
        run_lint || exit_code=1
    elif [[ "$run_test_only" == "true" ]]; then
        run_tests || exit_code=1
    fi

    echo ""
    if [[ $exit_code -eq 0 ]]; then
        success "All checks passed!"
    else
        error "Some checks failed"
    fi

    exit $exit_code
}

main "$@"
