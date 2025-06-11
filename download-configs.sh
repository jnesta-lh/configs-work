#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

# Get the directory of this script:
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR"

git pull

curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/AutoHotkey.ahk" --output "/c/Users/jnesta/OneDrive - LogixHealth Inc/Documents/Scripts/AutoHotkey.ahk"
curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/vscode/keybindings.json" --output "/c/Users/jnesta/AppData/Roaming/Code/User/keybindings.json"
curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/vscode/settings.json" --output "/c/Users/jnesta/AppData/Roaming/Code/User/settings.json"
# TODO: Terminal config

echo "Downloaded the configs."
