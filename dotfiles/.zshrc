# ==================================================

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/zinit

# install zinit
test -d "${ZINIT_HOME}" || {
  mkdir -p "${ZINIT_HOME}"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"/bin
}

# instant mode p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source "${ZINIT_HOME}"/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ==================================================

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit snippet OMZL::grep.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh

zinit load unixorn/kubectx-zshplugin

zinit snippet https://github.com/warbaque/dotfiles/blob/main/dotfiles/.p10k.zsh

zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit load zdharma-continuum/history-search-multi-word
zstyle ":history-search-multi-word" page-size "LINES/2"
zstyle ":history-search-multi-word" highlight-color "bold,fg=yellow"
zstyle ":plugin:history-search-multi-word" active "bold,standout"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice lucid as"program" pick"bin/git-dsf"
zinit load zdharma-continuum/zsh-diff-so-fancy

zinit pack for ls_colors

# ==================================================
# PROJECT SPECIFIC CUSTOMIZATION
test -d "${HOME}/dotfiles" && {
  . <("${HOME}/dotfiles/zshrc-extras/init.zsh")
}

autoload -Uz compinit; compinit;
zinit cdreplay -q
(( $+functions[zshrc-extras] )) && zshrc-extras reload

# ===[ALIASES]======================================

alias gs="git status --short"
alias gd="git diff"
alias gl="git log --graph --decorate --oneline --all"
alias gll="git log --graph --pretty=format:'%C(auto)%>|(12)%h%Creset %C(green)%cr %C(bold blue)%aN%Creset%C(auto)%d%Creset %s' --abbrev-commit --all"

alias ls="ls --color=auto"
alias diff="diff --color"

# ==================================================
#setopt 'auto_cd'    'no_bg_nice'    'no_flow_control'  'hist_find_no_dups'
#setopt 'c_bases'    'hist_verify'   'auto_param_slash' 'hist_ignore_space'
#setopt 'multios'    'always_to_end' 'complete_in_word' 'interactive_comments'
#setopt 'path_dirs'  'extended_glob' 'extended_history' 'hist_expire_dups_first'
#setopt 'auto_pushd' 'share_history' 'hist_ignore_dups' 'no_prompt_bang'
#setopt 'prompt_cr'  'prompt_sp'     'prompt_percent'   'no_prompt_subst'
#setopt 'no_bg_nice' 'no_aliases'    'typeset_silent'

kube-toggle() {
  if (( ${+POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND} )); then
    unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
  else
    POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND="${POWERLEVEL9K_KUBECONTEXT_COMMANDS}"
  fi
  p10k reload
  if zle; then
    zle push-input
    zle accept-line
  fi
}

# ==================================================

path+=("$HOME/.local/bin")