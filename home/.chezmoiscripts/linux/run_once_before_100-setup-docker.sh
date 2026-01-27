#!/usr/bin/env bash

set -eufo pipefail

if ! command -v docker &>/dev/null; then
  exit
fi

echo "SETTING UP DOCKER..."
# NOTE: Removed dangerous 'rm -rf ~/.docker' - preserves existing docker config
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"
