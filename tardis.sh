#!/usr/bin/env bash

session=$(find ~ ~/Documents/ -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$session" | tr . _)

tmux has-session -t "$session_name" 2> /dev/null
echo "$session_name"

if [[ $? == 0 ]]; then
  tmux switch-client -t "$session_name"
else
  tmux new-session -s "$session_name" -c "$session" -d
  tmux switch-client -t "$session_name"
fi

