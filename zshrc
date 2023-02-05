# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep nomatch
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/michael/.zshrc'

autoload -Uz compinit
compinit

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

source ~/.zsh_plugins.zsh

# p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^H' backward-kill-word

# 1Password magic
source ~/.agent-bridge.sh

# To customize prompt, run `p10k configure` or edit ~/dev/dotfiles/p10k.zsh.
[[ ! -f ~/dev/dotfiles/p10k.zsh ]] || source ~/dev/dotfiles/p10k.zsh

export GOPATH="$HOME/go"; export GOROOT="$HOME/.go"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
