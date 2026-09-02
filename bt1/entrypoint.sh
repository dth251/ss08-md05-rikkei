#!/bin/bash
set -e

if [ -z "$REPO_URL" ]; then
    echo "ERROR: REPO_URL environment variable is required (e.g. https://github.com/username/repo)"
    exit 1
fi

if [ -z "$RUNNER_TOKEN" ]; then
    echo "ERROR: RUNNER_TOKEN environment variable is required."
    exit 1
fi

RUNNER_NAME=${RUNNER_NAME:-"quickbite-runner-$(hostname)"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,linux,x64,docker"}
RUNNER_GROUP=${RUNNER_GROUP:-"Default"}

# Cho phép chạy dưới quyền root trong container để tương tác thông suốt với Docker socket
export RUNNER_ALLOW_RUNASROOT="1"
export HOME="/root"

echo "=== Cấu hình GitHub Actions Runner ==="
echo "Repository: $REPO_URL"
echo "Runner Name: $RUNNER_NAME"
echo "Labels: $RUNNER_LABELS"
echo "======================================"

cd /actions-runner

# Đăng ký runner
./config.sh \
    --url "$REPO_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --labels "$RUNNER_LABELS" \
    --runnergroup "$RUNNER_GROUP" \
    --unattended \
    --replace

cleanup() {
    echo "Dọn dẹp và hủy đăng ký Runner..."
    ./config.sh remove --token "$RUNNER_TOKEN"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

echo "Khởi động Runner lắng nghe jobs..."
./run.sh &
wait $!
