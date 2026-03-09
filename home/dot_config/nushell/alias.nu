alias .. = cd ..
alias ... = cd ../../
alias .... = cd ../../../
alias ..... = cd ../../../../


alias c = clear
alias q = exit
alias nv = nvim
alias vi = nvim
alias lg = with-env { TERM: "xterm-256color" } { lazygit }
# alias py = python
alias l = eza -lah
alias ts = tree-sitter
alias tsa = tree-sitter-alpha
alias tss = tree-sitter-stable
alias trim = ^awk '{\$1=\$1;print}'
alias s = start "."
alias n = neovide --fork
alias nf = neovide --fork (fzf)
alias gbc = git checkout (git branch --all | fzf | str replace '(\*)' '' | str trim)

alias fzf = fzf --bind 'enter:become(nvim {})' --preview 'bat --color=always --style=header,grid --line-range=:500 {}'

alias zss = yazi "~/AppData/Local/nvim-data/sessions"
