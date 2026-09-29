# History
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000

setopt share_history
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify

# Navigation with arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Completion
[[ -d /opt/homebrew/share/zsh/site-functions ]] &&
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' squeeze-slashes true

# Tools
command -v fzf >/dev/null && eval "$(fzf --zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Aliases
alias reload="source ~/.zshrc"
alias edit="nvim ~/.zshrc"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Plugins
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# direnv: load per-project env vars
eval "$(direnv hook zsh)"

eval "$(mise activate zsh)"
