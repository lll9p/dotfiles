# Abbreviate home path
def home_abbrev [os_name] {
  let is_home_in_path = ($env.PWD | str starts-with $nu.home-dir)
  if $is_home_in_path {
    if ($os_name =~ "windows") {
      let home = ($nu.home-dir | str replace -a "\\" "/")
      let pwd = ($env.PWD | str replace -a "\\" "/")
      $pwd | str replace $home '~'
    } else {
      $env.PWD | str replace $nu.home-dir '~'
    }
  } else {
    if ($os_name =~ "windows") {
      # remove the C: from the path
      $env.PWD | str replace -a "\\" "/" | str substring 2..
    } else {
      $env.PWD
    }
  }
}

def path_abbrev_if_needed [apath] {
  let splits = ($apath | split row '/')
  $splits | last
}

def get_index_change_count [gs] {
  let index_new = ($gs | get idx_added_staged)
  let index_modified = ($gs | get idx_modified_staged)
  let index_deleted = ($gs | get idx_deleted_staged)
  let index_renamed = ($gs | get idx_renamed)
  let index_typechanged = ($gs | get idx_type_changed)

  $index_new + $index_modified + $index_deleted + $index_renamed + $index_typechanged
}

def get_working_tree_count [gs] {
  let wt_modified = ($gs | get wt_modified)
  let wt_deleted = ($gs | get wt_deleted)
  let wt_typechanged = ($gs | get wt_type_changed)
  let wt_renamed = ($gs | get wt_renamed)

  $wt_modified + $wt_deleted + $wt_typechanged + $wt_renamed
}

def get_conflicted_count [gs] {
  ($gs | get conflicts)
}

def get_untracked_count [gs] {
  ($gs | get wt_untracked)
}

def get_branch_name [gs] {
  let br = ($gs | get branch)
  if $br == "no_branch" {
    ""
  } else {
    $br
  }
}

def get_ahead_count [gs] {
  ($gs | get ahead)
}

def get_behind_count [gs] {
  ($gs | get behind)
}

# Fast git status check using native nushell (no plugin overhead)
def get_git_info [] {
  # Single atomic git call to get both branch and status
  # --porcelain: machine readable
  # -b: include branch info
  let git_status = (do -i { git status --porcelain -b } | complete)

  if $git_status.exit_code != 0 {
    return { branch: "", status: "" }
  }

  let lines = ($git_status.stdout | lines)
  if ($lines | is-empty) { return { branch: "", status: "" } }

  # ## branch...remote
  let branch_line = ($lines | first)
  # Remove '## ' and potential tracking info '...'
  let branch = ($branch_line | str replace "## " "" | split row "..." | first | str trim)

  # If there are more lines than the header, it's dirty
  let is_dirty = ($lines | length) > 1
  let status = if $is_dirty { "×" } else { "·" }

  { branch: $branch, status: $status }
}

export def create_prompt [] {
  if ("TERM_IN_NEOVIM" in $env) {
    return ""
  }

  let os = $nu.os-info
  let display_path = path_abbrev_if_needed (home_abbrev $os.name)
  let is_home_in_path = ($env.PWD | str starts-with $nu.home-dir)

  # Fast git info (no plugin, no heavy status parsing)
  let git_info = (get_git_info)
  let branch_name = $git_info.branch
  let repo_status = $git_info.status

  let path_segment = (if (($is_home_in_path) and ($branch_name == "")) {
    [
      (char -u f015)
      (char space)
      $display_path
    ] | str join
  } else {
      [
        (char -u f07c)
        (char space)
        $display_path
      ] | str join
    })

  let git_segment = (if ($branch_name != "") {
    ["("
      (char -u e0a0)
      ($branch_name)
      $repo_status
      ")"
    ] | str join
  })

  let last_exit = if ($env.LAST_EXIT_CODE == 0) { "" } else {
    $"(ansi light_red_bold)✘ ($env.LAST_EXIT_CODE | to text)*"
  }

  [
    $path_segment
    $git_segment
    (char space)
    "<"
    $last_exit
    $env.CMD_DURATION_MS
    "ms"
  ] | str join

}

$env.PROMPT_COMMAND = { (create_prompt) }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = "> "
$env.PROMPT_INDICATOR_VI_NORMAL = "> "
$env.PROMPT_INDICATOR_VI_INSERT = ">: "
$env.PROMPT_MULTILINE_INDICATOR = ">::: "
