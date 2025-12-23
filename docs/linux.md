# LLL9P LINUX DOTFILES

Optimized for Arch Linux and EndeavourOS.

---

## 📦 Package Management

### Pacman & AUR
Managed via `.chezmoidata/pkgs/arch-based.yml`.
- **Essentials**: `chezmoi`, `git`, `lazygit`, `tmux`, `wget`.
- **Terminal**: `alacritty`, `neovim`, `yazi`, `starship`, `zoxide`, `nushell`.
- **CLI Tools**: `aria2`, `bat`, `dust`, `eza`, `fd`, `fzf`, `just`, `procs`, `ripgrep`, `sd`, `btop`, `fastfetch`.
- **Dev**: `docker`, `docker-compose`.

---

## 🐳 Docker Setup
Docker is configured to run without sudo.
The script `.chezmoiscripts/linux/run_once_before_100-setup-docker.sh` handles the setup:
- Installs docker, docker-buildx, docker-compose.
- Adds user to `docker` group.
- Configures `daemon.json` for performance and logging.

---

## TODO

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [TODO](#todo)
  - [Browser](#browser)
    - [Brave](#brave)
- [UTILS](#utils)
  - [Arch installation](#arch-installation)
  - [Systemctl](#systemctl)
  - [XDG](#xdg)
  - [Tmux](#tmux)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## TODO

### Browser

- Memory Saver
  ```
  www.youtube.com
  www.messenger.com
  ```

#### Brave

- Shield
  - Custom lists
    ```
    https://abpvn.com/vip/kev.txt?ublock
    https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt
    https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist
    https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock-mining.txt?_=rawlist
    ```
  - Custom filters: [custom filter](./dot_config/browser-data/adblock/custom_filters.txt)

---

## UTILS

### Arch installation

```sh
setfont ter-132n
```

### User Creation

After a fresh Arch install, create your user and grant sudo privileges:

```sh
# 1. Create user with home directory and default shell
useradd -m -G wheel -s /bin/bash <username>

# 2. Set password
passwd <username>

# 3. Enable wheel group in sudoers (uncomment the line)
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL

# 4. (Optional) Allow passwordless sudo
# Uncomment: %wheel ALL=(ALL:ALL) NOPASSWD: ALL

# 5. Switch to the new user
su - <username>

# 6. Run the bootstrap script
curl -fsSL https://raw.githubusercontent.com/lll9p/chezmoi/main/bootstrap-linux.sh | bash
# Or clone the repo first:
git clone https://github.com/lll9p/chezmoi.git ~/.local/share/chezmoi
~/.local/share/chezmoi/bootstrap-linux.sh
```

### Systemctl

- Clean services
  ```sh
  systemctl reset-failed
  ```

### XDG

- Set default application
  > Example for Brave
  ```sh
  xdg-settings set default-web-browser brave-browser.desktop
  xdg-mime default brave-browser.desktop x-scheme-handler/http
  xdg-mime default brave-browser.desktop x-scheme-handler/https
  xdg-mime default brave-browser.desktop x-scheme-handler/mailto
  ```

### Tmux

- attach starting directory to current session ([Source](https://stackoverflow.com/a/54444853/23173098))
  ```tmux
  attach-session -t . -c /path/to/new/directory
  ```
