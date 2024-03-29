

if type -q exa
    alias c "clear"
    # navigation aliases
	alias ll "exa -l -g --icons"
	alias lla "ll -a --icons"
    alias lg "lazygit" 
    alias ls "exa --icons"
    alias la "find . -maxdepth 1 -type f"
    alias f "fzf --height=20"
    # git aliases
    alias ga "git add"
    alias gc "git clone"
    alias gco "git checkout"
    alias gi "git init"
    alias gf "git fetch"
    alias gcm "git commit"
    alias gs "git status"
    alias gpl "git pull"
    alias ga "git add"
    alias gd "git diff"
    alias gph "git push"
end

neofetch
