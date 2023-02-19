# key bindings

# sub string search
bindkey '^[[1;5A' history-substring-search-up
bindkey '^[[1;5B' history-substring-search-down

# go back or forward a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# control + backspace to delete a word
bindkey '^H' backward-kill-word

# autocomplete
#autoload -U compinit; compinit

# set history size to 2^16 and other options
export HISTSIZE=65536
export SAVEHIST=65536

# we set the history already in the zshrc file
# so we can just set other options here
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups