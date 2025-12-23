# Terminal & Shell Environment

This repository provides a unified terminal experience across Windows and Linux.

## 🐚 Nushell
[Nushell](https://www.nushell.sh/) is the primary shell for its structured data handling and modern syntax.

- **Completions**: Extensively configured in `home/dot_config/nushell/completions.nu.tmpl`. Automatically synced from `nu_scripts` via `chezmoiexternals`.
- **Plugins**: Includes `polars`, `query`, `gstat`, `inc`, `formats` for enhanced data processing.
- **Theme**: Uses Catppuccin Macchiato.
- **Integration**: Seamless integration with `zoxide`, `fzf`, and `starship`.

## 🖥️ Terminal Emulators

### Alacritty
Cross-platform, GPU-accelerated terminal emulator.
- Config: `home/dot_config/alacritty/alacritty.toml.tmpl`
- Theme: Catppuccin Macchiato (Auto-synced from `alacritty-theme` repository).

### Windows Terminal (Preview)
Primary terminal for Windows.
- Integrated with Nushell and PowerShell.

## 📂 File Manager: Yazi
[Yazi](https://github.com/sxyazi/yazi) is used as the terminal file manager.
- Blazing fast, written in Rust.
- Image preview support.
- **Cross-platform**: Configured with consistent keybindings and openers across Windows and Linux.

## 📜 Multiplexer: Tmux (Linux)
- Config: `dot_config/tmux/tmux.conf`
- Used for session management on Linux environments.

---

## 💁 References

- [tmux italic](https://gist.github.com/gyribeiro/4192af1aced7a1b555df06bd3781a722)
- [true color](https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6)
