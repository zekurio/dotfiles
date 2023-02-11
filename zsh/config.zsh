# key bindings

# sub string search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# go back or forward a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# control + backspace to delete a word
bindkey '^H' backward-kill-word

# hist

# max history size
export HISTSIZE='65536';
export HISTFILESIZE="${HISTSIZE}";

# ignore duplicates and space prefix
export HISTCONTROL='ignoreboth';

# set format
export HISTTIMEFORMAT="%F %T "

setopt autocd

unsetopt beep nomatch