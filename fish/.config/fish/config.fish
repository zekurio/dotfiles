# disable greeting
set fish_greeting

# starship
starship init fish | source

set -x SSH_AUTH_SOCK /home/$USER/.bitwarden-ssh-agent.sock

if status is-interactive
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
