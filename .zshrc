# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
autoload -U compinit && compinit
ZSH_THEME="robbyrussell"


plugins=(fzf git z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


#terminal aliases
alias install='sudo pacman -S'
alias remove="sudo pacman -R"
alias update="sudo pacman -Syu"
alias update_cursor="sh ~/.local/Scripts/cursor-update"
# alias vim='nvim'
alias c='clear'
alias lg='lazygit'
alias e="exit"
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
alias cursor="/home/$USER/Applications/cursor.AppImage --no-sandbox"

bindkey -s ^f "~/.local/Scripts/tardis\n"
bindkey -s ^s "~/.local/Scripts/infobank\n"
bindkey -s ^e "~/.local/Scripts/exit-script\n"


# vscodium-portable amos 
alias code-amos="$HOME/apps/vscodium-portable/codium \
  --user-data-dir $HOME/apps/vscodium-portable/data \
  --extensions-dir $HOME/apps/vscodium-portable/extensions"
# pnpm
export PNPM_HOME="/home/nishu/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/nishu/.bun/_bun" ] && source "/home/nishu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/home/nishu/.opencode/bin:$PATH
