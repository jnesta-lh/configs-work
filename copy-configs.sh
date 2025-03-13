#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

# Get the directory of this script:
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR"

DST_DIR="$DIR/configs"

cp "/c/Users/jnesta/OneDrive - LogixHealth Inc/Documents/Scripts/AutoHotkey.ahk" "$DST_DIR/"
cp "/c/Users/jnesta/AppData/Roaming/Code/User/settings.json" "$DST_DIR/"
cp "/c/Users/jnesta/AppData/Roaming/Code/User/keybindings.json" "$DST_DIR/"

git add --all && git commit -m "updates" && git pull && git push

LATEST_SHA1=$(git rev-parse HEAD)
start chrome "https://github.com/jnesta-lh/configs/commit/$LATEST_SHA1"
