
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

# Zoxide Initialization
let zoxide_cache = ($nu.home-path | path join ".zoxide.nu")
if (which zoxide | is-not-empty) {
    if not ($zoxide_cache | path exists) {
        zoxide init nushell | save -f $zoxide_cache
    }
} else {
    # Ensure the file exists but is empty/harmless if zoxide is missing
    if not ($zoxide_cache | path exists) or (($zoxide_cache | path expand | open | is-empty) == false) {
        "# zoxide not found" | save -f $zoxide_cache
    }
}
# path jumping
if ($zoxide_cache | path exists) {
    source ~/.zoxide.nu
}
