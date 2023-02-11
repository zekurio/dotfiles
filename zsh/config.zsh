# key bindings

# sub string search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# go back or forward a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# control + backspace to delete a word
bindkey '^H' backward-kill-word

# history and other settings
HISTFILE=$ZSH_LOCAL/history
HISTSIZE=65536
SAVEHIST=65536
setopt autocd
unsetopt beep nomatch
zstyle :compinstall filename $HOME/.zshrc

autoload -Uz compinit
compinit