export ZSH="$HOME/.oh-my-zsh"
autoload -U compinit && compinit
ZSH_THEME="robbyrussell"

plugins=(fzf git z zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# pacman
alias install='sudo pacman -S'
alias remove="sudo pacman -R"
alias update="sudo pacman -Syu"

# general
alias c='clear'
alias e="exit"
alias lg='lazygit'

# npm
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias ni="npm install"

# git
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

# tmux
alias tls="tmux ls"
alias tlw="tmux list-windows"

# suffix aliases
alias -s tsx=nvim

# global aliases
alias -g G="| rg"

# cursor
alias cursor="$HOME/Applications/cursor.AppImage --no-sandbox"
alias update_cursor="sh $HOME/.local/Scripts/cursor-update"

# keybindings
bindkey -s ^f "$HOME/.local/Scripts/tardis\n"
bindkey -s ^s "$HOME/.local/Scripts/infobank\n"
bindkey -s ^e "$HOME/.local/Scripts/exit-script\n"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
