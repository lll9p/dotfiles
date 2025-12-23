<h1 align=center>
  LLL9P MULTI-PLATFORM DOTFILES
</h1>

<div align=center>
  <p>A unified, modular, and AI-enhanced development environment for Windows and Linux (Arch-based).</p>
</div>

<div align=center>
  <a href="https://github.com/lll9p/chezmoi/commits/main">
    <img alt="Last commit" src="https://img.shields.io/github/last-commit/lll9p/chezmoi?style=for-the-badge&color=f2cdcd&labelColor=363a4f"/>
  </a>
  <img alt="Repo size" src="https://img.shields.io/github/repo-size/lll9p/chezmoi?style=for-the-badge&color=eba0ac&labelColor=363a4f"/>
  <a href="https://www.chezmoi.io/">
    <img alt="Chezmoi" src="https://img.shields.io/badge/chezmoi-fab387?style=for-the-badge"/>
  </a>
</div>

<div align=center>
  <img alt="Arch" src="https://img.shields.io/badge/Arch-89b4fa?logo=arch-linux&logoColor=white&style=for-the-badge"/>
  <img alt="EndeavourOS" src="https://img.shields.io/badge/endeavour%20os-b4befe?logo=endeavouros&logoColor=white&style=for-the-badge"/>
  <img alt="Windows" src="https://img.shields.io/badge/Windows-74c7ec?style=for-the-badge&logo=windows&logoColor=white"/>
</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</div>

---

## ToC

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [🚀 Key Features](#-key-features)
- [⚙️ Installation](#-installation)
- [📝 Other notes](#-other-notes)
- [💁 References](#-references)
  - [Wallpaper](#wallpaper)
  - [Other dotfiles](#other-dotfiles)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## 🚀 Key Features

- **Editor**: [Neovim](https://neovim.io/) with a modular Lua configuration.
  - AI-enhanced: Integrated with [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) and [Codeium](https://codeium.com/).
  - Modern UI: [blink.cmp](https://github.com/Saghen/blink.cmp) for completion, [snacks.nvim](https://github.com/folke/snacks.nvim), and [catppuccin](https://github.com/catppuccin/nvim) theme.
- **Shell**: [Nushell](https://www.nushell.sh/) - A modern, structured shell for both Windows and Linux.
  - **Plugins**: Integrated with `nu_plugin_polars`, `nu_plugin_query`, `nu_plugin_gstat`, etc.
  - **Completions**: Auto-synced completions from `nu_scripts`.
- **Terminal**: [Alacritty](https://alacritty.org/) (Windows/Linux) & [Windows Terminal Preview](https://github.com/microsoft/terminal).
- **Package Management**:
  - **Windows**: [Scoop](https://scoop.sh/) & [Winget](https://github.com/microsoft/winget-cli).
  - **Linux**: [Pacman](https://wiki.archlinux.org/title/Pacman) (Arch/EndeavourOS).
  - **Python**: [uv](https://github.com/astral-sh/uv) for lightning-fast environment management.
- **Tools**:
  - [Yazi](https://github.com/sxyazi/yazi): Blazing fast terminal file manager.
  - [Lazygit](https://github.com/jesseduffield/lazygit): Simple terminal UI for git commands.
  - [Delta](https://github.com/dandavison/delta): A viewer for git and diff output.

---

## ⚙️ Installation

### 1. SSH Setup
- **Linux**
  ```sh
  eval "$(ssh-agent -s)"
  chmod 700 ~/.ssh/
  chmod 644 ~/.ssh/id_ed25519.pub
  chmod 600 ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519
  ```
- **Windows**
  ```powershell
  Set-Service ssh-agent -StartupType Automatic
  Start-Service ssh-agent
  Ssh-Add "$env:USERPROFILE/.ssh/id_ed25519"
  ```

### 2. Encryption Setup (age)
This repository uses [age](https://github.com/FiloSottile/age) for encrypting secrets.
- You need to have your age private key at `~/.age-key.txt` (or `$HOME\.age-key.txt` on Windows).
- If you are just exploring, you can skip applying encrypted files:
  ```sh
  chezmoi apply --exclude=encrypted
  ```

### 3. Initialize Dotfiles
Install [chezmoi](https://www.chezmoi.io/) and run:
- **Bash / Zsh / Fish**
  ```sh
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --ssh --depth 1 lll9p
  ```
- **PowerShell**
  ```powershell
  iex "&{$(irm 'https://get.chezmoi.io/ps1')} -- init --apply --ssh --depth 1 lll9p"
  ```

### 4. GPG Setup (Optional)
Import your GPG keys for signing commits:
```sh
gpg --import public.gpg
gpg --import secret.gpg
# Trust the key
gpg --edit-key <KEY_ID>
# trust -> 5 -> y -> quit
```
> [!TIP]
> On Windows, it's recommended to use GPG from [Gpg4win](https://www.gpg4win.org/) or Git Bash.

---

## 📝 Other notes

- [Windows](./docs/windows.md)
- [Linux](./docs/linux.md)
- [Terminal](./docs/terminal.md)

---

## 💁 References

### Other dotfiles

<details>
<summary>
Click to expand
</summary>

- For use
  - <https://github.com/HyDE-Project/HyDE>
  - <https://github.com/JaKooLit/Hyprland-Dots>
  - <https://github.com/end-4/dots-hyprland>
  - <https://github.com/gh0stzk/dotfiles> (BSPWM)
  - <https://github.com/koeqaife/hyprland-material-you>
  - <https://github.com/prasanthrangan/hyprdots>
  - <https://gitlab.com/stephan-raabe/dotfiles>
- Chezmoi
  - <https://github.com/KevinNitroG/dotfiles>
  - <https://github.com/megabyte-labs/install.doctor>
  - <https://github.com/lildude/dotfiles/> (Have config for codespace)
- Others
  - <https://github.com/2KAbhishek/dots2k>
  - <https://github.com/2nthony/dotfiles> (Lazygit?)
  - <https://github.com/Alexis12119/dotfiles>
  - <https://github.com/Cybersnake223/Hypr>
  - <https://github.com/Integralist/dotfiles>
  - <https://github.com/JoosepAlviste/dotfiles>
  - <https://github.com/amitds1997/dotfiles> (setup for arch and mac, git stuff, something is new to me)
  - <https://github.com/asilvadesigns/config>
  - <https://github.com/bahamas10/dotfiles> (YSAP)
  - <https://github.com/chaneyzorn/dotfiles>
  - <https://github.com/craftzdog/dotfiles-public>
  - <https://github.com/dlvhdr/dotfiles>
  - <https://github.com/dreamsofautonomy/zensh>
  - <https://github.com/linkarzu/dotfiles-latest>
  - <https://github.com/mischavandenburg/dotfiles>
  - <https://github.com/nguyenvukhang/docker-dev>
  - <https://github.com/nguyenvukhang/dots> (git config!)
  - <https://github.com/omerxx/dotfiles> (have good tmux plugins)
  - <https://github.com/p3nguin-kun/dotfiles>
  - <https://github.com/petobens/dotfiles> (X config, tmux for linux & mac)
  - <https://github.com/rusty-electron/dotfiles>
  - <https://github.com/siduck/dotfiles>
  - <https://github.com/stevearc/dotfiles>
  - <https://github.com/wincent/wincent> (Old dotfiles 😱)
  </details>
