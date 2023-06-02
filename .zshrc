if [ -t 0 ] && [[ -z $TMUX ]] && [[ $- = *i* ]]; then exec tmux; fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
autoload -U compinit && compinit
ZSH_THEME="robbyrussell"


plugins=(git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias vim='nvim'
alias e='exit'
alias c='clear'

alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
#Git aliases
alias gi="git init"
alias gco="git clone"
alias ga="git add ."
alias gph="git push"
alias gpl="git pull"
alias gs="git status"
alias gsh="git stash"
alias gc="git commit"
alias gcm="git commit -m"
alias grh="git reset --hard"
alias gd="git diff"
