# dotfiles

macOS (Apple Silicon) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
The Neovim config lives in its own repo: [slmbakkenes/nvim](https://github.com/slmbakkenes/nvim).

Each top-level folder is a stow package that mirrors `$HOME`:

| Package    | Links                        |
| ---------- | ---------------------------- |
| `zsh`      | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `tmux`     | `~/.tmux.conf`               |
| `starship` | `~/.config/starship.toml`    |
| `kitty`    | `~/.config/kitty/`           |
| `btop`     | `~/.config/btop/`            |
| `mise`     | `~/.config/mise/` (LSP servers + formatters for nvim) |

## Install

```bash
brew install stow kitty tmux starship btop mise zoxide fzf yazi direnv \
  zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-iosevka-nerd-font
git clone https://github.com/slmbakkenes/dotfiles.git ~/Development/projects/dotfiles
cd ~/Development/projects/dotfiles && stow zsh tmux starship kitty btop mise
mise install
```

Stow refuses to overwrite existing files — move any pre-existing config out
of the way first. tmux plugins: install [tpm](https://github.com/tmux-plugins/tpm),
then `prefix + I`.

## Theme

Gruvbox Dark everywhere (kitty, tmux, starship, btop, nvim):

| Role    | Hex       |
| ------- | --------- |
| bg      | `#282828` |
| bg1     | `#3c3836` |
| bg3     | `#665c54` |
| fg      | `#ebdbb2` |
| fg0     | `#fbf1c7` |
| red     | `#cc241d` |
| green   | `#98971a` |
| yellow  | `#d79921` |
| blue    | `#458588` |
| purple  | `#b16286` |
| aqua    | `#689d6a` |
| orange  | `#d65d0e` |

kitty's theme is `kitty/.config/kitty/current-theme.conf`, written by
`kitten themes "Gruvbox Dark"`.
