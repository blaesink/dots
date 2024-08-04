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

alias gl="git sl"
alias gs="git status"
alias gd="git diff"
alias gsh="git show"
alias zi="__zoxide_zi"
alias z="__zoxide_z"
# alias ff="clear && fd -t f | fzy | xargs -I _ $EDITOR _"
alias ff="hx (fd -t f | sk -m)"
alias zj="zellij"

if test -z (pgrep ssh-agent)
    eval (ssh-agent -c) >/dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

function git-fuzzy-switch
    git switch (git for-each-ref --format='%(refname:short)' refs/heads | fzy)
end

alias gfs git-fuzzy-switch

zoxide init fish | source
jj util completion fish | source

if type -q starship
    eval (starship init fish)
end
