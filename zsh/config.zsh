# key bindings

# sub string search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# go back or forward a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# control + backspace to delete a word
bindkey '^H' backward-kill-word

# set history size to 2^16 and other options
export SAVEHIST=65536;

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY