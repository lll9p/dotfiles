#!/usr/bin/env bash

set -euo pipefail

GNUPG_DIR="${HOME}/.gnupg"

# Skip if gnupg directory doesn't exist
if [[ ! -d "${GNUPG_DIR}" ]]; then
    echo "GNUPG directory not found, skipping permission setup."
    exit 0
fi

echo "Setting GPG directory permissions..."
chown -R "$(whoami)" "${GNUPG_DIR}/"
find "${GNUPG_DIR}" -type d -exec chmod 700 {} \;
find "${GNUPG_DIR}" -type f -exec chmod 600 {} \;
echo "GPG permissions set successfully."
