if status is-interactive
    # Commands to run in interactive sessions can go here
end
if type -q exa
	alias ll "exa -l -g --icons"
	alias lla "ll -a"
end

neofetch
