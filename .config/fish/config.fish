# disable greeting
set fish_greeting

# only load starship if not in pure TTY
if not string match -q '/dev/tty*' (tty)
    starship init fish | source
end

set -x SSH_AUTH_SOCK $HOME/.1password/agent.sock

alias dots 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if status is-interactive
end

# Set the default editor to nvim
set -Ux EDITOR nvim
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
