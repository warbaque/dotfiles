#! /usr/bin/env bash


set -o errexit -o noclobber -o pipefail
params="$(getopt -o n -l dry-run --name "$0" -- "$@")"
eval set -- "$params"

while true; do
  case "$1" in
    -n|--dry-run)
      dryrun=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Not implemented: $1" >&2
      exit 1
      ;;
    esac
done


install-missing() {
  local missing=()
  for cmd in "${@}"; do
    command -v "${cmd}" >/dev/null 2>&1 || missing+=("${cmd}")
  done
  if [ ${#missing[@]} -ne 0 ]; then
    echo "[install-missing] (${missing})"
    if [ "${dryrun}" = true ]; then
      echo "sudo apt-get update && sudo apt-get install -f ${missing[@]}"
    else
      sudo apt-get update && sudo apt-get install -f ${missing[@]}
    fi
  else
    echo "[install-missing] everything installed (${@})"
  fi
}

mklink() {
  local src="${1}"
  local dst="${2}"
  local sudo="${3}"

  if [ "$(realpath -P "${src}")" = "$(realpath -P "${dst}")" ]; then
    local status="LINK OK"
  elif [ -e "${dst}" ]; then
    local status="OVERWRITE"
  else
    local status="NEW LINK"
  fi

  printf "[%-10s] %-20s -> %-20s\n" "$status" "${dst#$HOME/}" "${src#$HOME/}"
  [ "${dryrun}" = true ] || ${sudo} ln -sf "${src}" "${dst}"
}

install-missing zsh git tmux terminator fdfind
mklink $(which fdfind) /usr/local/bin/fd sudo

if [ "${SHELL}" = "$(which zsh)" ]; then
  echo "[shell: already zsh]"
else
  echo "[shell: change ${SHELL} to zsh"
  [ "${dryrun}" = true ] || sudo chsh -s $(which zsh) $(whoami)
fi

if test -d "$HOME/dotfiles"; then
  echo "[dotfiles: OK]"
else
  echo "[dotfiles: git clone]"
  [ "${dryrun}" = true ] || (cd "$HOME" && git clone https://github.com/warbaque/dotfiles.git)
fi

mklink $HOME/{dotfiles/,}.zshrc
mklink $HOME/{dotfiles/,}.tmux.conf
mklink $HOME/{dotfiles/,}.config/terminator
mklink $HOME/{dotfiles/,}.gitconfig
