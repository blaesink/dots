source ~/.config/fish/k8s.fish

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
set -gx GHQ_ROOT $HOME/prj

# Aliases
if type -q eza
    alias ls="eza -l"
    alias la="eza -la"
else if type -q exa
    alias ls="exa -l"
    alias la="exa -la"
end

alias cat="bat"
alias gl="git sl"
alias gs="git status"
alias gd="git diff"
alias gsh="git show"
alias zi="__zoxide_zi"
alias z="__zoxide_z"
alias zj="zellij"
alias new="exec fish"

if test -z (pgrep ssh-agent)
    eval (ssh-agent -c) >/dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

function git-fuzzy-switch
    git switch (git for-each-ref --format='%(refname:short)' refs/heads | fzy)
end

# Switch into a directory in my code projects.
function repo
    set -l r (fd --base-directory ~/prj -t d -d 1 -a | sk)
    and cd $r
end

# Find a file in the directory tree and edit it.
# Accepts a positional arg for an extension to look for.
function findedit
    if test -n "$argv[1]"
        set -f file (fd -t f -a -e $argv[1] | sk | awk -F ":" '{print $1}')
    else
        set -f file (fd -t f -a | sk | awk -F ":" '{print $1}')
    end

    if test -n "$file"
        $EDITOR $file
    end
end

alias ff="findedit"

function zellij-select
    set session ( zj ls -n | awk -F " " '{print $1}' | sk )
    and zellij a $session
end

alias zjs zellij-select
alias gfs git-fuzzy-switch


# Mimic Bash's !!
function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

abbr -a kc kubectl

zoxide init fish | source
jj util completion fish | source

if type -q starship
    eval (starship init fish)
end

direnv hook fish | source
