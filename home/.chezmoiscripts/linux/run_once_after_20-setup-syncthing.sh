#!/usr/bin/env bash
# Enable Syncthing as a user service
# Equivalent to Windows startup shortcut

set -euo pipefail

echo "Setting up Syncthing service..."

# Check if syncthing is installed
if ! command -v syncthing &> /dev/null; then
    echo "[WARNING] Syncthing not installed. Skipping service setup."
    exit 0
fi

# Enable and start user service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

echo "[OK] Syncthing service enabled and started."
echo "    Access web UI at: http://localhost:8384"
