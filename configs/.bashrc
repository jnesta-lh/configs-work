BASH_PROFILE_PATH=~/.config/bash_profile_remote
rm -f "$BASH_PROFILE_PATH"
curl https://raw.githubusercontent.com/Zamiell/configs/refs/heads/main/bash/.bash_profile --silent --output "$BASH_PROFILE_PATH"
# cp ~/Repositories/configs/bash/.bash_profile "$BASH_PROFILE_PATH"
source "$BASH_PROFILE_PATH"
