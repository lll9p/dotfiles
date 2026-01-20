# Initialize keychain for SSH key management
# https://www.nushell.sh/cookbook/ssh_agent.html#keychain
def --env setup-keychain [] {
    if (which keychain | is-empty) {
        print "Keychain not found, it's over."
        return 1
    }

 keychain --eval --agents ssh id_ed25519
  | lines
  | where not ($it | is-empty)
  | parse "{k}={v}; export {k2};"
  | select k v
  | transpose --header-row
  | into record
  | load-env
}
def --env setup-gpg [] {
    # Skip if already initialized this session
    if ('__GPG_INITIALIZED' in $env) { return }

    let os = $nu.os-info.name

    # Only set GPG_TTY if not already set
    if ('GPG_TTY' not-in $env) {
        $env.GPG_TTY = (do -i { ^tty | complete | get stdout | str trim })
    }

    if $os == "linux" {
        # Only set SSH_AUTH_SOCK if not already set by system
        if ('SSH_AUTH_SOCK' not-in $env) {
            $env.SSH_AUTH_SOCK = (do -i { ^gpgconf --list-dirs agent-ssh-socket | complete | get stdout | str trim })
        }
        # updatestartuptty is fast, always run
        do -i { ^gpg-connect-agent updatestartuptty /bye } | ignore
    } else if $os == "windows" {
        # Optimization: ps on Windows is slow. Just try to launch checking is internal.
        do -i { ^gpgconf --launch gpg-agent } | ignore
    }

    $env.__GPG_INITIALIZED = true
}

# Add a note to a file
def note [...args] {
    let note_text = ($args | str join " ")
    let date = (date now | format date "%Y-%m-%d %H:%M:%S")
    print $"date: ($date)\n($note_text)\n" | save --append $"($nu.home-dir)/drafts.txt"
}

# Make a directory if it doesn't exist and cd into it
def mkcd [dirname: string] {
    if ($dirname | path exists) {
        print $"Directory ($dirname) already exists!"
        cd $dirname
    } else {
        mkdir $dirname
        cd $dirname
    }
}

# Diff with bat
def batdiff [] {
    git diff --name-only --relative --diff-filter=d
    | lines
    | each { |it| bat --diff $it }
}


# Check if a Rust command exists, and install it if it doesn't
def check_cargo_commands [] {
    if (which cargo | is-empty) {
        print "Cargo not found! Please install Rust first with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`"
        return 1
    }

    let commands = [
        { name: "fmt",     install: ["rustup", "component", "add", "rustfmt"]                },
        { name: "clippy",  install: ["rustup", "component", "add", "clippy"]                 },
        { name: "audit",   install: ["cargo",  "install",   "cargo-audit", "--features=fix"] },
        { name: "nextest", install: ["cargo",  "install",   "cargo-nextest"]                 },
        { name: "upgrade", install: ["cargo",  "install",   "cargo-edit"]                    },
    ]

    for cmd in $commands {
        if (do { ^cargo $cmd.name --version } | complete).exit_code != 0 {
            print $"Installing cargo-($cmd.name)..."
            run-external $cmd.install
        }
    }
}

# update all installed packages
export def 'uv updateall' [] {
  # some packages should not be update
  let locks = [
              nvidia
              sympy
            ]
  let outdated = uv pip list --outdated --format=json
                   | from json | get name
                   | where {|o| not ($locks | any {|lock| ($o =~ $lock) })  }
  for $o in $outdated {
    uv pip install -U $o
  }
  let conflicts = uv pip check | complete | get stderr
                  |lines | find --regex "`.*`,"
                  | str replace --regex "^.*`(.*)`,.*$" "$1"
  for $c in $conflicts {
    uv pip install $c
  }
}



# $env.VIRTUAL_ENVS:
# <list>:
#  <record>:
#   dir: path # venv directory
#   old_PATH  # <-> $env.PATH
#   old_PYTHONHOME  # <-> $env.PYTHONHOME
#   old_PYTHONPATH: <list<str>> # <-> $env.PYTHONPATH


# deactivate the newest venv
export def --env deactivate [] {
 # TODO: use return or something instead of default if nu ever adds it..

 let venv = ( # the venv you want to deactivate
  $env | get --optional VIRTUAL_ENVS | default []
  | reverse | get --optional 0 | default {}
 )

 load-env {
  VIRTUAL_ENVS: ( # remove it from the list
   $env | get --optional VIRTUAL_ENVS | default []
   | drop 1
  )

  # reset env vars
  PATH: ($venv | get --optional old_PATH | default $env.PATH)
  PYTHONHOME: ($venv | get --optional old_PYTHONHOME | default ($env | get --optional PYTHONHOME))
 }
}

# list the active venvs
export def list-env [] {
  ls ($env | get --optional VIRTUAL_ENVS) | get name
}

# register a venv
export def --env activate [
 dir: path = ''  # the venv directory (contains bin/ and pyvenv.cfg) (default: autodetect)
] {
 let dir = (
  if $dir == '' {
   (ls */pyvenv.cfg).0.name | path dirname
  } else {$dir}
 )
 let dir = ($dir | path expand)
 load-env {
  VIRTUAL_ENVS: (
   $env | get --optional VIRTUAL_ENVS | default []
   | append {
    dir: $dir
    old_PATH: $env.PATH
    old_PYTHONHOME: ($env | get --optional PYTHONHOME)
    old_PYTHONPATH: ($env | get --optional PYTHONPATH)
   }
  )
  PATH: (
   $env.PATH
   | prepend (if $nu.os-info.name == "windows" { $dir | path join "Scripts" } else { $dir | path join "bin" })
  )
  VIRTUAL_ENV: $dir  # for other scripts, etc
  PYTHONHOME: null
  PYTHONPATH: ([
   (if ($'($env.PWD)/tests' | path exists) { $'($env.PWD)/tests' }),
   (if ($'($env.PWD)/src' | path exists) { $'($env.PWD)/src' }),
  ] | flatten | compact)
 }
}
# change scoop-cn proxy url
def scoop-cn [url: string] {
    let url = $url | str replace --regex "/$" ""
    scoop config scoop_repo $"($url)/https://github.com/ScoopInstaller/Scoop"
    git -C $"($nu.home-dir)/scoop/buckets/main" remote set-url origin $"($url)/https://github.com/ScoopInstaller/Main"
    git -C $"($nu.home-dir)/scoop/buckets/scoop-cn" remote set-url origin $"($url)/https://github.com/duzyn/scoop-cn"
}

def --env proxies [] {
  $env.http_proxy = "localhost:1081"
  $env.https_proxy = "localhost:1081"
  $env.socks_proxy = "localhost:1081"
}

def --env un-proxies [] {
  $env.http_proxy = ""
  $env.https_proxy = ""
  $env.socks_proxy = ""
}

def --env setup-pyvenv [] {
  $env.VIRTUAL_ENVS = "/usr/local/share/virtualenvs"
}

def --env setup-locale [] {
  if (($env | get --optional FROM | is-not-empty ) and ($env.FROM == "windows")) {
      $env.LANG = "zh_CN.UTF-8"
      $env.LC_ALL = "zh_CN.UTF-8"
  } else {
      $env.LANG = "en_US.UTF-8"
      $env.LC_ALL = "en_US.UTF-8"
  }
}

def --env startup [] {
    setup-locale
    setup-gpg
    if ($nu.os-info.name == "linux") {
      setup-pyvenv
      activate /usr/local/share/virtualenvs/common
    } else if ($nu.os-info.name == "windows") {
      # Activate work venv on Windows
      let work_venv = ($env.LOCALAPPDATA | path join "Programs" "virtualenvs" "work")
      if ($work_venv | path exists) {
        activate $work_venv
      }
    }
}
