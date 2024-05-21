# disable greeting
set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set starship env var and load starship
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

# aliases
alias ssh "kitten ssh"