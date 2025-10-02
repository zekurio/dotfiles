if status is-interactive
  set -x SSH_AUTH_SOCK ~/.bitwarden-ssh-agent.sock

  set -g fish_greeting

  set -xg STARSHIP_CONFIG ~/.config/starship/starship.toml

  starship init fish | source

  set -gx PNPM_HOME ~/.local/share/pnpm
  if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
  end
end

