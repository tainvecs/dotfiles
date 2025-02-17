#!/bin/zsh

# Check if Docker is installed
if ! command -v docker >/dev/null; then
    echo "Error: Docker is not installed or not in PATH." >&2
    return 1
fi
