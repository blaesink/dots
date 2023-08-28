set fish_greeting

fish_add_path ~/.local/bin
fish_add_path ~/.local/share/

abbr --erase z &>/dev/null
abbr --erase zi &>/dev/null

if type -q lvim
  set -gx EDITOR lvim
  alias v="lvim"
  alias vim="lvim"
end

# Aliases
alias ls="exa -l"
alias la="exa -la"

alias sls="sl status"
alias sld="sl diff"
alias zi="__zoxide_zi"
alias z="__zoxide_z"
alias ff="clear && fd -t f | fzy | xargs -I _ $EDITOR _"

zoxide init fish | source

if type -q starship
  eval (starship init fish)
end

