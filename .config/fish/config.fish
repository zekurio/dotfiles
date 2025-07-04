# disable greeting
set fish_greeting

# only load starship if not in pure TTY
if not string match -q '/dev/tty*' (tty)
    starship init fish | source
end

set -x SSH_AUTH_SOCK $HOME/.1password/agent.sock

# Set the default editor to nvim
set -Ux EDITOR nvim

# Add .local/bin to the PATH
set -x PATH $HOME/.local/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH