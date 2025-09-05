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

for-each-link() {
  local src="${1:a}"
  local op="${2}"

  if test -f "${src}"; then
    local config="${src/${available}\//}"
    local dst="${enabled}/${config//\//--}"
    case "${op}" in
      create) ln -sf "../available/${config}" "${dst}" ;;
      delete) rm -f "${dst}" ;;
      status)
        if [ "$(realpath -P "${src}")" = "$(realpath -P "${dst}")" ]; then
          printf  "${GREEN}[✓] ${CYAN}enabled  ${RESET} ${config}\n"
        else
          printf "${YELLOW}[ ] ${CYAN}available${RESET} ${config}\n"
        fi
        printf "${DARK_GRAY}$(cat "${src}")${RESET}\n"
        ;;
    esac
  elif test -d "${src}"; then
    for config in "${src}"/*; do
      for-each-link "${config}" "${op}"
    done
  else
    echo "${0}: failed to ${op} link '${src}': Missing file"
  fi
}

zshrc-extras-mklink() { for-each-link "${1}" create;  }
zshrc-extras-rmlink() { for-each-link "${1}" delete;  }
zshrc-extras-status() { for-each-link "${1}" status;  }

zshrc-extras-setup() {
  case "${1}" in
    enable|add) (( $+2 )) && zshrc-extras-mklink "${available}/${2}" ;;
    disable|del|rm) (( $+2 )) && zshrc-extras-rmlink "${available}/${2}" ;;
    enable-all) zshrc-extras-mklink "${available}" ;;
    disable-all|reset) zshrc-extras-rmlink "${available}" ;;
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
      for project in "${script_root}/projects"/*(NnOn); do
        test -e "\${project}/cli" &&
          . <("\${project}/cli" init)
        test -d "\${project}/autoload" &&
          for file in "\${project}/autoload"/*(NnOn); do
            . "\${file:A}"
          done
      done
      ;;
    *) "${script_root}/init.zsh" "\${@}" ;;
  esac
}
helper() {
  "${script_root}/../setup/shell" "\${@}"
}
fpath+=( "${script_root}/completions" )
for project in "${script_root}/projects"/*(NnOn); do
  test -d "\${project}/completions" &&
    fpath+=( "'"\${project:A}/completions"'" )
done
EOF
}

if [ -t 1 ]; then
  zshrc-extras-setup "${@}"
  echo
  zshrc-extras-status "${available}"
else
  zshrc-extras-init
  for project in "${script_root}/projects"/*(NnOn); do
    test -e "${project}/cli" &&
      "${project}/cli" init
    test -d "${project}/autoload" &&
      for file in "${project}/autoload"/*(NnOn); do
        echo . "${file:A}"
      done
    test -d "${project}/completions" &&
      echo 'fpath+=( "'"${project:A}/completions"'" )'
  done
fi
