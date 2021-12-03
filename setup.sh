#! /usr/bin/env bash

install-missing() {
  local missing=()
  for cmd in "${@}"; do
    command -v "${cmd}" >/dev/null 2>&1 || missing+=("${cmd}")
  done
  if [ ${#missing[@]} -ne 0 ]; then
    sudo apt-get update && sudo apt-get install -f ${missing[@]}
  fi
}


install-missing zsh git tmux terminator fdfind
sudo ln -s $(which fdfind) /usr/local/bin/fd

test -d dotfiles || git clone https://github.com/warbaque/dotfiles.git

sudo chsh -s $(which zsh) $(whoami)

ln -sf $HOME/{dotfiles,}/.zshrc
ln -sf $HOME/{dotfiles,}/.tmux.conf
ln -sf $HOME/{dotfiles,}/.config/terminator

