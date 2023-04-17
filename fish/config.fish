

if type -q exa
    # navigation aliases
	alias ll "exa -l -g --icons"
	alias lla "ll -a --icons"
    alias lg "lazygit" 
    alias ls "exa --icons"
    alias la "find . -maxdepth 1 -type f"
    alias f "fzf --height=20"
    # git aliases
    alias gc "git clone"
    alias gp "git pull"
    alias ga "git add"
    alias gd "git diff"
    alias gp "git push"
end

neofetch
