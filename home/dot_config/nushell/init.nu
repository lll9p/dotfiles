
source envs.nu
source prompt.nu
source alias.nu
source functions.nu
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

startup

# path jumping
if ("~/.zoxide.nu" | path expand | path exists) {
    source ~/.zoxide.nu
}
