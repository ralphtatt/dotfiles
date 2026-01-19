#!/usr/bin/env bash

set -euo pipefail

# Usage:
#   popup-cmd <key> <command...>
# Examples:
#   popup-cmd ollama "ollama run llama3.1"
#
# This opens a persistent popup backed by a dedicated tmux session.
# It creates one window per *origin session* per <key>, started in the current pane directory.

key="${1:-}"
shift || true
cmd="${*:-}"

if [[ -z "$key" || -z "$cmd" ]]; then
  echo "usage: popup-cmd <key> <command...>" >&2
  exit 2
fi

float_sess="__float__"

# If invoked from inside the float session (i.e., likely inside popup), detach to close.
origin_sess="$(tmux display-message -p "#{session_name}")"
if [[ "$origin_sess" == "$float_sess" ]]; then
  tmux detach-client
  exit 0
fi

origin_path="$(tmux display-message -p "#{pane_current_path}")"

# Window name = "<key>-<origin session>", sanitized for tmux target syntax.
win="${key}-${origin_sess}"
win="${win//:/_}"
win="${win// /_}"

# Ensure float session exists
if ! tmux has-session -t "$float_sess" 2>/dev/null; then
  tmux new-session -d -s "$float_sess" -n "__bootstrap__"
fi

# Ensure window exists; if not, create it and start the command in origin dir
if ! tmux select-window -t "$float_sess:$win" 2>/dev/null; then
  tmux new-window -d -t "$float_sess:" -n "$win" -c "$origin_path" "$cmd"
  tmux kill-window -t "$float_sess:__bootstrap__" 2>/dev/null || true
fi

# Show it in a popup (persistent because it's a real tmux window)
tmux display-popup -E -w 80% -h 80% "tmux attach-session -t \"$float_sess\" \\; select-window -t \"$float_sess:$win\""
