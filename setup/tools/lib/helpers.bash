#! /usr/bin/env bash

# === [ANSI] ====================================

RESET='\e[0m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'

# ===============================================

DISTRO="$(lsb_release -is | tr '[:upper:]' '[:lower:]')"
CODENAME="$(lsb_release -cs)"

declare -A log_priority=(
  [TRACE]=0
  [DEBUG]=1
  [INFO]=2
  [WARN]=3
  [ERROR]=4
  [FATAL]=5
)

set_log_level() {
  log_level="${log_priority[$1]}"
  log INFO "log_level = ${1}"
}

log() {
  (( "${log_priority[$1]:-1}" < "${log_level:-2}" )) && return
  echo "[${1}] ${@:2}"
}

# ===============================================

with_tmp() {
  local tmp_dir="$(mktemp -d /tmp/dotfiles-installer-XXXXX)"
  log 'DEBUG' "created '${tmp_dir}'"
  trap "rm -rf ${tmp_dir}; log \"DEBUG\" \"deleted '${tmp_dir}'\"" EXIT
  cd "${tmp_dir}"
}

preinstall() { :; }

_install() {(
  preinstall "${1}"
  echo -e "${CYAN}Installing${RESET} [${YELLOW}${1}${RESET}]"
  "install_${1}" "${@:2}" | sed "s/^\r*/  /"
)}

_status() {
  local cmd="${1}"
  if command -v "${cmd}" >/dev/null 2>&1; then
    local is_installed='✓'
    local version="$(version_${cmd})";
  else
    local is_installed=' '
    local version="";
  fi
  printf "${is_installed}  %-12s %s\n" "${cmd}" "${version}"
}

apt_setup() {
  local key="/etc/apt/keyrings/${2}"
  sudo mkdir -p -- "$(dirname -- "${key}")"
  curl -fsSL "${1}" \
    | sudo gpg --yes --dearmor -o "${key}"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=${key}] ${3}" \
    | sudo tee "/etc/apt/sources.list.d/${4}"
}

# ===============================================

status() {
  echo -e "${CYAN}Status${RESET}"
  for cmd in "${tools[@]}"; do
    _status "${cmd}"
  done
}

# ===============================================

installer() {(
  if [[ "${1}" == all ]]; then
    for cmd in "${tools[@]}"; do
      _install "${cmd}"
    done
  elif [[ " ${tools[*]} " =~ " ${1} " ]]; then
    _install "${@}"
  fi
)}
