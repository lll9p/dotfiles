#!/usr/bin/env bash
# deploy-sysconfig.sh
# Interactive script to deploy system configuration files
# Run this script with sudo when you want to update system configs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSCONFIG_DIR="$SCRIPT_DIR/etc"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== System Configuration Deployment ===${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[WARNING] Not running as root. Will use sudo for file operations.${NC}"
    SUDO="sudo"
else
    SUDO=""
fi

deploy_file() {
    local src="$1"
    local dest="$2"
    local desc="$3"

    echo -e "\n${YELLOW}[$desc]${NC}"
    echo "  Source:      $src"
    echo "  Destination: $dest"

    if [[ ! -f "$src" ]]; then
        echo -e "  ${RED}[SKIP] Source file not found${NC}"
        return 1
    fi

    if [[ -f "$dest" ]]; then
        echo -e "  ${YELLOW}[EXISTS] Destination file exists${NC}"
        echo ""
        echo "  Diff (--- current  +++ new):"
        diff -u "$dest" "$src" || true
        echo ""
        read -p "  Overwrite? [y/N]: " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo -e "  ${YELLOW}[SKIP] User cancelled${NC}"
            return 0
        fi
        # Backup
        local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
        $SUDO cp "$dest" "$backup"
        echo -e "  ${GREEN}[BACKUP] Saved to: $backup${NC}"
    else
        read -p "  Create new file? [y/N]: " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo -e "  ${YELLOW}[SKIP] User cancelled${NC}"
            return 0
        fi
        # Create parent directory if needed
        $SUDO mkdir -p "$(dirname "$dest")"
    fi

    $SUDO cp "$src" "$dest"
    echo -e "  ${GREEN}[OK] Deployed successfully${NC}"
}

# Deploy Docker daemon.json
deploy_file \
    "$SYSCONFIG_DIR/docker/daemon.json" \
    "/etc/docker/daemon.json" \
    "Docker Daemon Config (registry mirrors)"

# Deploy containerd config.toml
deploy_file \
    "$SYSCONFIG_DIR/containerd/config.toml" \
    "/etc/containerd/config.toml" \
    "Containerd Config (registry mirrors)"

echo ""
echo -e "${GREEN}=== Deployment Complete ===${NC}"
echo ""
echo "You may need to restart services for changes to take effect:"
echo "  sudo systemctl restart docker"
echo "  sudo systemctl restart containerd"
