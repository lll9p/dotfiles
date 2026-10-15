
source env.nu
source alias.nu
source functions.nu
source prompt.nu
source codex.nu
source claude.nu
source completions.nu

source plugins.nu
source themes.nu

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"


$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000_000
  sync_on_enter: true
  isolation: true
}

# External completer example
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

$env.config.abbreviations = (
    $env.config.abbreviations?
    | default {}
    | merge {
        "proxy": "HTTP_PROXY=http://127.0.0.1:1081 HTTPS_PROXY=http://127.0.0.1:1081 ALL_PROXY=socks5://127.0.0.1:1081"
    }
)

startup

# Zoxide - sourced from generated file
source ~/.zoxide.nu
