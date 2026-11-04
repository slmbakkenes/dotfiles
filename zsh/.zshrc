# Drop CLAUDE_* vars inherited from a Claude Code session that no longer exists (e.g. kitty relaunched by Claude)
[[ -n $CLAUDE_PID ]] && ! kill -0 $CLAUDE_PID 2>/dev/null && unset ${(M)${(k)parameters}:#CLAUDE*} AI_AGENT

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

# Theme — Gruvbox dark/light, chosen per machine with `theme dark|light`.
# Re-apply on a fresh machine (no symlinks yet) or after starship.toml changed.
if [[ ! -e ~/.config/kitty/current-theme.conf || ~/.config/starship.toml -nt ~/.cache/starship.toml ]]; then
  theme apply
fi
export STARSHIP_CONFIG="$HOME/.cache/starship.toml"

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
