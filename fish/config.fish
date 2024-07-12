# disable greeting
set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        #exec Hyprland
    end
end

# set starship env var and load starship
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

# aliases
alias ssh "kitten ssh"

# set up go
set -gx GOPATH $HOME/go; set -gx GOROOT $HOME/.go; set -gx PATH $GOPATH/bin $PATH; # g-install: do NOT edit, see https://github.com/stefanmaric/g

# set up pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# set up bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# set up rustup
set -gx PATH "$HOME/.cargo/bin" $PATH;
