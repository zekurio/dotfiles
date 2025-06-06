# disable greeting
set fish_greeting

# only load starship if not in pure TTY
if not string match -q '/dev/tty*' (tty)
    starship init fish | source
end

set -x SSH_AUTH_SOCK /home/$USER/.bitwarden-ssh-agent.sock

if status is-interactive
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
