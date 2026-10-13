# instant mode p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

path+=("$HOME/.local/bin")

# ==================================================

ANTIDOTE=${ZDOTDIR:-$HOME}/.antidote

test -d "${ANTIDOTE}" || {
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ANTIDOTE}"
}

fpath=("${ANTIDOTE}"/functions $fpath)
autoload -Uz antidote

if [[ ! ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh -nt ${ZDOTDIR:-$HOME}/.zshrc ]]; then
  antidote bundle >|${ZDOTDIR:-$HOME}/.zsh_plugins.zsh <<PLUGINS
romkatv/powerlevel10k
warbaque/dotfiles path:dotfiles/.p10k.zsh

zsh-users/zsh-completions kind:fpath path:src

ohmyzsh/ohmyzsh path:lib/key-bindings.zsh
using:mattmc3/zephyr path:plugins
  color
  completion
  directory
  history
  zfunctions

unixorn/kubectx-zshplugin kind:defer
zdharma-continuum/history-search-multi-word kind:defer
zdharma-continuum/fast-syntax-highlighting kind:defer

zdharma-continuum/zsh-diff-so-fancy from:gh-r binstub:bin/git-dsf
PLUGINS
fi

source ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh

# ==================================================

zstyle ":plugin:history-search-multi-word" clear-on-cancel "yes"
zstyle ":plugin:history-search-multi-word" reset-prompt-protect 1

zstyle ":plugin:history-search-multi-word" page-size "LINES/2"
zstyle ":plugin:history-search-multi-word" highlight-color "bold,fg=yellow"
zstyle ":plugin:history-search-multi-word" active "bold,standout"

# HSMW can leave SIGINT ignored after cancelling recursive-edit with Powerlevel10k.
# Restore the prompt's handler after every search, including interrupted searches.
_dotfiles_init_history_search() {
  (( ${+functions[_dotfiles_history_search_original]} )) && return
  autoload +X history-search-multi-word || return
  functions -c history-search-multi-word _dotfiles_history_search_original
  history-search-multi-word() {
    {
      _dotfiles_history_search_original "$@"
    } always {
      if [[ -n ${__p9k_trapint-} ]]; then
        trap "$__p9k_trapint" INT
      fi
    }
  }
}
zsh-defer _dotfiles_init_history_search

# ==================================================

setopt auto_cd

# replace ls with eza
alias l='eza -al --color=always --group-directories-first --icons=always'
alias ls='eza --color=always --group-directories-first --icons=always'
alias la='eza -a --color=always --group-directories-first --icons=always'
alias ll='eza -l --color=always --group-directories-first --icons=always'
alias lt='eza -aT --color=always --group-directories-first --icons=always'
alias l.="eza -a | grep -e '^\.'"

# git
alias gs="git status --short"
alias gd="git diff"
alias gl="git log --graph --decorate --oneline --all"
alias gll="git log --graph --pretty=format:'%C(auto)%>|(12)%h%Creset %C(green)%cr %C(bold blue)%aN%Creset%C(auto)%d%Creset %s' --abbrev-commit --all"

# common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias hw='hwinfo --short'
alias big="expac -H M '%m\t%n' | sort -h | nl"

# pacman
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
alias update='sudo cachyos-rate-mirrors && sudo pacman -Syu'
alias mirror="sudo cachyos-rate-mirrors"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias cleanch="sudo paccache -r -k 2"
alias rmpkg="sudo pacman -Rsn"

# get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"