# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Overview

Personal Neovim configuration, cloned directly to `~/.config/nvim` on both macOS
and Arch Linux. Split out of [slmbakkenes/dotfiles](https://github.com/slmbakkenes/dotfiles),
which still holds the kitty / tmux / starship / btop packages.

## Portability rule

Every change must work on **both macOS and Arch**. Concretely:

- No absolute `/Users/...` or `/opt/homebrew` paths.
- Gate OS-specific behaviour on `vim.uv.os_uname().sysname == "Darwin"` rather
  than assuming macOS — `lua/sven/plugins/dap.lua` is the reference example, and
  it also gates the *plugin dependency*, not just the runtime path.
- Prefer `vim.fn.exepath(...)` over hardcoded binary locations.
- Anything machine-specific or employer-specific belongs in `lua/sven/local.lua`
  (gitignored, `pcall`-required from `init.lua`), never in a tracked file.

## Architecture

Entry point `init.lua` loads three things in order:

1. `sven.core` — options and keymaps (`lua/sven/core/`)
2. `sven.lazy` — bootstraps lazy.nvim, imports every spec under
   `lua/sven/plugins/` and `lua/sven/plugins/lsp/`
3. `sven.local` — optional, gitignored machine overrides

Each file in `lua/sven/plugins/` is a self-contained lazy.nvim plugin spec
returning a table. LSP setup is split across:

- `lua/sven/lsp.lua` — shared `on_attach` and capabilities
- `lua/sven/plugins/lsp/lsp.lua` — per-server configuration
- `lua/sven/plugins/lsp/mason.lua` — auto-install via mason
- `lua/sven/plugins/lsp/roslyn.lua` — C# via roslyn, outside mason
- `after/lsp/` — server overrides loaded after startup
- `after/ftplugin/` — filetype settings (java, cs, kotlin)

## Conventions

- One plugin per file in `lua/sven/plugins/`, named after the plugin.
- Keymaps for a plugin live in that plugin's spec, not in `core/keymaps.lua`;
  `core/keymaps.lua` is for plugin-independent bindings only.
- Every mapping gets a `desc` — which-key surfaces it.
- Leader is `Space`.

## Plugin lock file

`lazy-lock.json` is tracked. After `:Lazy sync`, commit the diff.

## Theme

Gruvbox Dark, medium contrast (`ellisonleao/gruvbox.nvim` in
`lua/sven/plugins/colorscheme.lua`), with `vim.o.background = "dark"` matching
`opt.background` in `lua/sven/core/options.lua`. Palette is shared with the
dotfiles repo — see its `CLAUDE.md` for the hex table.
