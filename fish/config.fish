if status is-interactive
and not set -q TMUX
    exec tmux
end   # Commands to run in interactive sessions can go here

if type -q exa
	alias ll "exa -l -g --icons"
	alias lla "ll -a"
end

neofetch
