#!/bin/bash

set -euo pipefail # Exit on errors and undefined variables.

curl "https://raw.githubusercontent.com/jnesta-lh/configs/refs/heads/main/configs/.bashrc" --output ~/.bash_extras
