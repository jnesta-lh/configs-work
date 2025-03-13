#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/AutoHotkey.ahk" --output "/c/Users/jnesta/OneDrive - LogixHealth Inc/Documents/Scripts/AutoHotkey.ahk"
curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/keybindings.json" --output "/c/Users/jnesta/AppData/Roaming/Code/User/keybindings.json"
curl --silent "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/settings.json" --output "/c/Users/jnesta/AppData/Roaming/Code/User/settings.json"
