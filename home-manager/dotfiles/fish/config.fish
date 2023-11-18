set fish_greeting

fish_add_path ~/.local/bin
fish_add_path ~/.local/share/

abbr --erase z &>/dev/null
abbr --erase zi &>/dev/null

if type -q lvim
  alias v="lvim"
  alias vim="lvim"
end

set -gx EDITOR hx

# Aliases
if type -q eza
  alias ls="eza -l"
  alias la="eza -la"
else if type -q exa
  alias ls="exa -l"
  alias la="exa -la"
end

alias sls="sl status"
alias sld="sl diff"
alias zi="__zoxide_zi"
alias z="__zoxide_z"
alias ff="clear && fd -t f | fzy | xargs -I _ $EDITOR _"

alias zj="zellij"

if test -z (pgrep ssh-agent)
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

zoxide init fish | source

if type -q starship
  eval (starship init fish)
end

