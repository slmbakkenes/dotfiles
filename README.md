# dotfiles

macOS (Apple Silicon) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
The Neovim config lives in its own repo: [slmbakkenes/nvim](https://github.com/slmbakkenes/nvim).

Each top-level folder is a stow package that mirrors `$HOME`:

| Package    | Links                        |
| ---------- | ---------------------------- |
| `zsh`      | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `starship` | `~/.config/starship.toml`    |
| `kitty`    | `~/.config/kitty/`           |
| `btop`     | `~/.config/btop/`            |
| `mise`     | `~/.config/mise/` (LSP servers + formatters for nvim) |
| `bin`      | `~/.local/bin/theme`         |

## Install

```bash
brew install stow kitty starship btop mise zoxide fzf yazi direnv \
  zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-iosevka-nerd-font
git clone https://github.com/slmbakkenes/dotfiles.git ~/Development/projects/dotfiles
cd ~/Development/projects/dotfiles && stow zsh starship kitty btop mise bin
mise install
theme dark   # or: theme light
```

`.stowrc` sets the target to `$HOME`, so `stow` works from anywhere the repo is cloned.

Stow refuses to overwrite existing files — move any pre-existing config out
of the way first.

## Theme

Gruvbox everywhere (kitty, starship, btop, nvim), dark or light per machine:

```bash
theme          # print the current theme
theme light    # or: theme dark, theme toggle
```

The choice is saved in `~/.config/theme` (per machine, not in git). `theme`
points `kitty/.config/kitty/current-theme.conf` and
`btop/.config/btop/themes/current.theme` at the dark or light file (both
symlinks are gitignored), writes `~/.cache/starship.toml` with the matching
palette, and signals nvim. Open kitty windows, shell prompts and nvim switch
right away; btop picks it up on its next start. A new shell runs
`theme apply` itself if the symlinks are missing.

Dark:

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

Light uses the same neutrals inverted (bg `#fbf1c7`, fg `#3c3836`) with the
faded accents: red `#9d0006`, green `#79740e`, yellow `#b57614`,
blue `#076678`, purple `#8f3f71`, aqua `#427b58`, orange `#af3a03`.
