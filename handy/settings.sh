#!/usr/bin/env bash
# Merges handy/settings.json into Handy's settings store, which also holds the
# API keys and per-machine device choices, so those survive. The cleanup prompt
# names people, so it lives in the private iCloud folder rather than this repo.
set -e

DOT="$(cd "$(dirname "$0")/.." && pwd)"
store="$HOME/Library/Application Support/com.pais.handy/settings_store.json"
: "${DOT_PRIVATE:=$HOME/Library/Mobile Documents/com~apple~CloudDocs/Dotfiles}"
prompt="$DOT_PRIVATE/handy/cleanup-prompt.md"
prompt_id="prompt_1775231818128"
profile="${DOT_PROFILE:-$("$DOT/macos/profile.sh")}"

if [ ! -f "$store" ]; then
  echo "handy: no settings store yet; open Handy once, then re-run"
  exit 0
fi

# Handy writes its in-memory settings back over the store, so it is stopped
# first and reopened afterwards.
running=0
if pgrep -xq handy; then running=1; pkill -x handy; sleep 1; fi

if [ ! -f "$prompt" ]; then
  echo "handy: $prompt not found; keeping the installed cleanup prompt"
  prompt=/dev/null
fi

out="$(mktemp)"
jq --slurpfile s "$DOT/handy/settings.json" --slurpfile b "$DOT/handy/bindings.$profile.json" \
  --rawfile p "$prompt" --arg id "$prompt_id" '
  (.settings.post_process_prompts // [] | map(select(.id == $id))) as $installed
  | .settings *= $s[0]
  | .settings.bindings |= with_entries(.value.current_binding = ($b[0][.key] // .value.current_binding))
  | .settings.post_process_prompts += (
      if ($p | length) > 0
      then [{id: $id, name: "Clean Up Transcript", prompt: ($p | sub("\n+$"; ""))}]
      else $installed end)
' "$store" > "$out"
mv "$out" "$store"
echo "handy: settings applied ($profile hotkeys)"

if [ "$running" = 1 ]; then open -a Handy; fi
