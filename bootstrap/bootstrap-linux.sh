#!/bin/bash
set -euo pipefail

# Bootstrap script for Arch Linux
# 1. Checks prerequisites (Arch, Git, Chezmoi)
# 2. Provision Age key for decryption
# 3. Handover to chezmoi init --apply

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Bootstrapping Dotfiles for Linux <==${NC}"

# Check for Arch Linux
if [ -f /etc/arch-release ]; then
  echo -e "${GREEN}[✓] Arch Linux detected${NC}"
else
  echo -e "${YELLOW}[!] Warning: Not running on Arch Linux. This setup is optimized for Arch.${NC}"
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Install dependencies
echo -e "${YELLOW}[*] Checking dependencies...${NC}"
PACKAGES=""
if ! command -v git &>/dev/null; then PACKAGES="$PACKAGES git"; fi
if ! command -v chezmoi &>/dev/null; then PACKAGES="$PACKAGES chezmoi"; fi

if [ -n "$PACKAGES" ]; then
  echo -e "${YELLOW}[*] Installing missing packages:${PACKAGES}${NC}"
  sudo pacman -S --needed --noconfirm $PACKAGES
else
  echo -e "${GREEN}[✓] Dependencies met (git, chezmoi)${NC}"
fi

# Provision Age Key
KEY_PATH="$HOME/.age-key.txt"
if [ ! -f "$KEY_PATH" ]; then
  echo -e "${RED}[!] Age secret key not found at $KEY_PATH${NC}"
  echo -e "${YELLOW}Enter your Age secret key (starts with AGE-SECRET-KEY-):${NC}"
  read -r AGE_KEY

  if [[ "$AGE_KEY" != AGE-SECRET-KEY-* ]]; then
    echo -e "${RED}[X] Invalid key format. Must start with AGE-SECRET-KEY-${NC}"
    exit 1
  fi

  echo "$AGE_KEY" >"$KEY_PATH"
  chmod 600 "$KEY_PATH"
  echo -e "${GREEN}[✓] Key saved to $KEY_PATH${NC}"
else
  echo -e "${GREEN}[✓] Age key present${NC}"
fi

# Handover to Chezmoi
echo -e "${GREEN}==> Handing over to Chezmoi...${NC}"
# Use current directory as source if script is run from inside repo
SCRIPT_DIR=$(dirname "$(realpath "$0")")
chezmoi init --apply --source "$SCRIPT_DIR"
