# dotfiles

macOS (Apple Silicon) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level folder is a stow package that mirrors `$HOME`:

| Package    | Links                        |
| ---------- | ---------------------------- |
| `zsh`      | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `starship` | `~/.config/starship.toml`    |
| `nvim`     | `~/.config/nvim/` (see [its README](nvim/.config/nvim/README.md)) |
| `kitty`    | `~/.config/kitty/`           |
| `btop`     | `~/.config/btop/`            |
| `yazi`     | `~/.config/yazi/` (Gruvbox dark/light flavors) |
| `mise`     | `~/.config/mise/` (LSP servers + formatters for nvim) |
| `bin`      | `~/.local/bin/theme`         |
| `homebrew` | `~/.Brewfile` (every brew formula, cask and cargo tool) |

## Install

```bash
git clone https://github.com/slmbakkenes/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
brew bundle --file=homebrew/.Brewfile
stow zsh starship nvim kitty btop yazi mise bin homebrew
mise install
theme dark   # or: theme light
```

`.stowrc` sets the target to `$HOME`, so `stow` works from anywhere the repo is cloned.

Stow refuses to overwrite existing files — move any pre-existing config out
of the way first.

## Claude Code

Claude Code config (`~/.claude`) and the `sven-mods` plugin marketplace live in
the private [claude](https://github.com/slmbakkenes/claude) repo. The nvim side
of its `nvim-live` mod is `nvim/.config/nvim/lua/sven/claude.lua`.

## Homebrew

`~/.Brewfile` is the source of truth for what's installed. Language servers,
formatters, node and other dev tools live in mise instead, not brew.

```bash
brew bundle check --global            # anything missing?
brew bundle cleanup --global          # list installs not in the Brewfile
brew bundle cleanup --global --force  # ...and uninstall them
brew bundle dump --global --force     # save the current state after adding something
```

## Theme

Gruvbox everywhere (kitty, starship, btop, yazi, nvim), dark or light per machine:

```bash
theme          # print the current theme
theme light    # or: theme dark, theme toggle
```

The choice is saved in `~/.config/theme` (per machine, not in git). `theme`
points `kitty/.config/kitty/current-theme.conf` and
`btop/.config/btop/themes/current.theme` at the dark or light file (both
symlinks are gitignored), writes `~/.cache/starship.toml` with the matching
palette, and signals nvim. Open kitty windows, shell prompts and nvim switch
right away; btop picks it up on its next start. yazi needs no switch of its
own: it asks kitty whether the background is dark or light and loads the
`gruvbox-dark` or `gruvbox-light` flavor from `yazi/.config/yazi/flavors/`.
A new shell runs `theme apply` itself if the symlinks are missing.

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
