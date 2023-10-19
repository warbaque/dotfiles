#! /usr/bin/env zsh

# === [ANSI] ========================================

RESET='\e[0m'
CYAN='\e[1;36m'
YELLOW='\e[0;33m'
GREEN='\e[0;32m'
DARK_GRAY='\e[0;90m'

# ===================================================

script_root="${${(%):-%x}:a:h}"
available="${script_root}/available"
enabled="${script_root}/enabled"

mkdir -p "${available}"
mkdir -p "${enabled}"

zshrc-extras-check() {
  if [ "$(realpath -P "${enabled}/${1}")" = "$(realpath -P "${available}/${1}")" ]; then
    printf "${GREEN}[✓] ${CYAN}enabled${RESET} ${1}\n"
    printf "${DARK_GRAY}$(cat "${enabled}/${1}")${RESET}\n"
  else
    printf "${YELLOW}[ ] ${CYAN}available${RESET} ${1}\n"
    printf "${DARK_GRAY}$(cat "${available}/${1}")${RESET}\n"
  fi
}

zshrc-extras-mklink() {
  if test -f "${available}/${1}"; then
    ln -s "../available/${1}" "${enabled}/${1}"
  else
    echo "${0}: failed to create link '${available}/${1}': Missing file"
  fi
}

zshrc-extras-rmlink() {
  if test -f "${enabled}/${1}"; then
    rm "${enabled}/${1}"
  else
    echo "${0}: failed to delete link '${enabled}/${1}': Missing file"
  fi
}

for-each-config() {
  for config in "${1}"/*; do
    ${2} ${config##*/}
  done
}

zshrc-extras-setup() {
  case "${1}" in
    enable|add) zshrc-extras-mklink "${2}" ;;
    disable|del|rm) zshrc-extras-rmlink "${2}" ;;
    enable-all) for-each-config "${available}" zshrc-extras-mklink ;;
    disable-all|reset) for-each-config "${enabled}" zshrc-extras-rmlink ;;
    status|list|ls) ;;
    help|"")
      echo "usage: zshrc-extras <cmd> [<args>...]"
      echo
      echo "  enable <file>       enable config (alias: add)"
      echo "  enable-all          enable all configs"
      echo "  disable <file>      disable config (aliases: del rm)"
      echo "  disable-all         disable all configs (alias: reset)"
      echo "  <cmd> <file>        open {file} with {cmd}"
      echo
      echo "  load <file>         load available <file>"
      echo "  reload              load all enabled files"
      ;;
    *) "${1}" "${available}/${2}"
  esac
}

zshrc-extras-init() {
cat << EOF
zshrc-extras() {
  local config
  case "\${1}" in
    load)
      config="${available}/\${2}"
      . "\${config}"
      echo sourced "\${config}"
      ;;
    reload)
      for config in "${enabled}"/*(NnOn); do
        . "\${config}"
      done
      ;;
    *) "${script_root}/init.zsh" "\${@}" ;;
  esac
}
helper() {
  "${script_root}/../setup/shell" "\${@}"
}
fpath+=( "${script_root}/completions" )
EOF
}

if [ -t 1 ]; then
  zshrc-extras-setup "${@}"
  echo
  for-each-config "${available}" zshrc-extras-check
else
  zshrc-extras-init
fi
