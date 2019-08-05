ZPLUG_HOME=$HOME/.zplug
ZPLUG_LOADFILE=$HOME/dotfiles/packages.zsh
ZPLUG_CACHE_DIR=$HOME/.cache/zplug
ZPLUG_LOG_LOAD_SUCCESS=false
ZPLUG_LOG_LOAD_FAILURE=false

{
  [[ -d $ZPLUG_HOME ]] || git clone https://github.com/zplug/zplug $ZPLUG_HOME
}

source "$ZPLUG_HOME/init.zsh"

zplug "zplug/zplug"

zplug "lib/directories",            from:oh-my-zsh
zplug "lib/history",                from:oh-my-zsh
zplug "lib/completion",             from:oh-my-zsh
zplug "lib/git",                    from:oh-my-zsh
zplug "lib/grep",                   from:oh-my-zsh
zplug "lib/key-bindings",           from:oh-my-zsh
zplug "lib/theme-and-appearance",   from:oh-my-zsh

zplug "romkatv/powerlevel10k",      use:powerlevel10k.zsh-theme, as:theme
zplug "warbaque/dotfiles",          use:.purepower

zplug "psprint/history-search-multi-word", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug check || zplug install

PATH=/usr/local/bin:$PATH

# aliases and functions
alias gs="git status --short"
alias gd="git diff"
alias gl="git log --graph --decorate --pretty=oneline --abbrev-commit --all"

# editor
export EDITOR=vim

zplug load

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ":history-search-multi-word" page-size "16"
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"
zstyle ":plugin:history-search-multi-word" synhl "yes"
zstyle ":plugin:history-search-multi-word" active "bg=white,fg=black"
zstyle ":plugin:history-search-multi-word" check-paths "yes"
# Number of entries to show (default is $LINES/3)
# Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
# Whether to perform syntax highlighting (default true)
# Effect on active history entry. Try: standout, bold, bg=blue (default underline)
# Whether to check paths for existence and mark with magenta (default true)

# Enable highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=cyan
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=fg=blue

# project specific customization
project-settings() {
  local settings="$HOME/workspace/settings.zsh"
  case "$1" in
    reload) [[ -r $settings ]] && . "$settings" || : ;;
    "")
        echo "Settings"
        [ -L "$settings" ] &&
        echo "  link: $(realpath -s "$settings")"
        echo "  file: $(realpath -P "$settings")"
        echo
        echo "Usage:"
        echo "  $0 reload       reload settings"
        echo "  $0 [cmd]        open settings with [cmd]"
    ;;
    *) $1 "$settings" ;;
  esac
}

project-settings reload
