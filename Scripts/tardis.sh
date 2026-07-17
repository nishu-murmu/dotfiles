#!/usr/bin/env bash


# script for opening directory with tmux session
session=$(find ~ ~/Documents/ -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$session" | tr . _)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session" -d
fi

is_tmux_attached=$(echo $TMUX)

if [[ -z "$is_tmux_attached" ]]; then
  tmux a -t "$session_name"
else
  tmux switch-client -t "$session_name"
fi
