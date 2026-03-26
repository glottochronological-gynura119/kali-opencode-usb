#!/bin/bash
# Script to run tests and verify code quality

set -e  # Exit on error

TARGET=${1:-all}

setup_venv() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo "===== Using active virtual environment: $VIRTUAL_ENV ====="
		return
	fi

	if [ -d "venv" ]; then
		echo "===== Using existing virtual environment: venv ====="
		source venv/bin/activate
		return
	fi

	if [ -d ".venv" ]; then
		echo "===== Using existing virtual environment: .venv ====="
		source .venv/bin/activate
		return
	fi

	echo "===== Creating virtual environment ====="
	python3 -m venv .venv
	source .venv/bin/activate
}

install_dev() {
	echo "===== Installing dependencies ====="
	pip install -e ".[dev]"
}

ensure_tool() {
	TOOL_NAME="$1"
	if ! command -v "$TOOL_NAME" >/dev/null 2>&1; then
		echo "===== Missing $TOOL_NAME, installing dev dependencies ====="
		install_dev
	fi
}

run_typecheck() {
	echo "===== Running type checking ====="
	ensure_tool pyright
	pyright --pythonpath "$(which python)"
}

run_lint() {
	echo "===== Running linting ====="
	ensure_tool ruff
	ruff check --fix .
}

run_format() {
	echo "===== Running formatting ====="
	ensure_tool ruff
	ruff format .
}

run_tests() {
	echo "===== Running tests ====="
	ensure_tool pytest
	pytest
}

run_tests_tools() {
	echo "===== Running tests/test_tools.py ====="
	ensure_tool pytest
	pytest tests/test_tools.py
}

run_tests_session() {
	echo "===== Running tests matching session ====="
	ensure_tool pytest
	pytest -k "session"
}

setup_venv

case "$TARGET" in
	install)
		install_dev
		;;
	typecheck)
		run_typecheck
		;;
	lint)
		run_lint
		;;
	format)
		run_format
		;;
	test)
		run_tests
		;;
	test-tools)
		run_tests_tools
		;;
	test-session)
		run_tests_session
		;;
	all)
		install_dev
		run_typecheck
		run_lint
		run_tests
		echo "===== All checks passed! ====="
		;;
	*)
		echo "Unknown target: $TARGET"
		echo "Usage: ./run_tests.sh [install|typecheck|lint|format|test|test-tools|test-session|all]"
		exit 1
		;;
esac