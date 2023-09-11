#if [ -t 0 ] && [[ -z $TMUX ]] && [[ $- = *i* ]]; then exec tmux; fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
autoload -U compinit && compinit
ZSH_THEME="robbyrussell"


plugins=(fzf git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


#terminal aliases
alias install='sudo pacman -S'
alias remove="sudo pacman -R"
alias update="sudo pacman -Syyu"
# alias vim='nvim'
alias c='clear'
alias lg='lazygit'
alias e="exit"
alias k='sh ~/exit-script'
# npm aliases
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias ni="npm install"
#Git aliases
alias gi="git init"
alias gcl="git clone"
alias ga="git add"
alias gph="git push"
alias gpl="git pull"
alias gs="git status"
alias gsh="git stash"
alias gc="git commit"
alias gco="git checkout"
alias gcm="git commit -m"
alias grh="git reset --hard"
alias grm="git rm --cached"
alias gd="git diff"
# tmux aliases
alias tls="tmux ls"
alias tlw="tmux list-windows"
#suffix alias
alias -s tsx=nvim
#global alias
alias -g G="| rg"

bindkey -s ^f "~/tardis\n"
bindkey -s ^s "~/infobank\n"
