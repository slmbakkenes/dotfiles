# nvim

Personal Neovim configuration. Runs on macOS and Arch Linux.

## Install

```bash
git clone git@github.com:slmbakkenes/nvim.git ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on first launch and installs everything; LSP servers
come from `mason.nvim` (C# roslyn is wired up separately). Treesitter parsers
compile on demand, so a C compiler must be present.

Leader is `Space` — press it and wait for [which-key](https://github.com/folke/which-key.nvim)
to list what's bound.

## Requirements

| Need                      | macOS                        | Arch                       |
| ------------------------- | ---------------------------- | -------------------------- |
| Neovim ≥ 0.10             | `brew install neovim`        | `pacman -S neovim`         |
| C compiler (treesitter)   | Xcode CLT                    | `pacman -S base-devel`     |
| `ripgrep`, `fd`           | `brew install ripgrep fd`    | `pacman -S ripgrep fd`     |
| Nerd Font                 | `font-iosevka-nerd-font`     | `ttf-iosevka-nerd`         |
| .NET debugging (optional) | bundled ARM64 netcoredbg     | `pacman -S netcoredbg`     |

## Layout

```
init.lua              entry point
lua/sven/core/        options + keymaps
lua/sven/lazy.lua     lazy.nvim bootstrap, imports plugins/ and plugins/lsp/
lua/sven/lsp.lua      shared on_attach + capabilities
lua/sven/plugins/     one file per plugin spec
lua/sven/plugins/lsp/ per-server setup, mason, roslyn
after/lsp/            server overrides applied after startup
after/ftplugin/       filetype settings (java, cs, kotlin)
```

## Machine-local config

Anything tied to one machine or one employer — debug targets with absolute
paths, private LSP settings, work-only keymaps — goes in `lua/sven/local.lua`,
which is gitignored. Copy `lua/sven/local.lua.example` to get started. It is
`pcall`-required at the end of `init.lua`, so its absence is not an error.

## Theme

Gruvbox Dark, medium contrast, via `ellisonleao/gruvbox.nvim`. Matches the
kitty / tmux / starship / btop theming in
[slmbakkenes/dotfiles](https://github.com/slmbakkenes/dotfiles).

## Updating plugins

`:Lazy sync`, then commit the resulting `lazy-lock.json`.
