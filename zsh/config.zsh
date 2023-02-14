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
export HISTSIZE=65536;