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

Entry point `init.lua` loads four things in order:

1. `sven.core` — options and keymaps (`lua/sven/core/`)
2. `sven.pack` — plugin management via the built-in |vim.pack| (nvim 0.12+):
   collects specs from every file under `lua/sven/plugins/`, registers build
   hooks on `PackChanged`, calls `vim.pack.add()`, then runs each spec's
   `setup()` (highest `priority` first — colorscheme — then alphabetical)
3. `sven.lsp` — native LSP setup (must run after pack so nvim-lspconfig and
   cmp-nvim-lsp are on the runtimepath)
4. `sven.local` — optional, gitignored machine overrides

Each file in `lua/sven/plugins/` returns one spec table or a list of them:
`{ src, name?, version?, build?, setup?, priority? }` (see the header comment
in `lua/sven/pack.lua`). Everything loads eagerly — there is deliberately no
lazy-loading framework; the one exception is nvim-java, whose heavyweight
`setup()` is deferred to the first java FileType event inside its own spec.

## LSP (native, nvim 0.11+ — no mason)

There is no mason and no per-server `setup()` framework. The flow:

- `lua/sven/plugins/lspconfig.lua` — nvim-lspconfig as a *data-only* plugin:
  it supplies `lsp/<server>.lua` definitions (cmd, filetypes, root_markers)
  plus `:LspRestart`; nothing is called on it.
- `lua/sven/lsp.lua` — the single LSP module: `vim.lsp.config("*")` with
  cmp-nvim-lsp capabilities, the `vim.lsp.enable({...})` server list,
  LspAttach keymaps, and diagnostic display.
- `after/lsp/<server>.lua` — per-server overrides. `lsp/` files across the
  runtimepath are deep-merged in rtp order (later wins), so `after/lsp/`
  overrides nvim-lspconfig's defaults. NOTE: a `lsp/` dir at the config root
  would be *earlier* in rtp than nvim-lspconfig and therefore lose — always
  put overrides in `after/lsp/`.
- Special cases enabled elsewhere: dartls (flutter-tools), jdtls (nvim-java
  spec), roslyn (`lua/sven/plugins/roslyn.lua` via roslyn.nvim).
- `after/ftplugin/` — filetype settings (java, cs, kotlin)

Server and tool binaries are system-installed (brew / pacman / npm / dotnet
tool) — the README "Requirements" table is the source of truth. When adding a
server: install the binary, add its name to `vim.lsp.enable()` in
`lua/sven/lsp.lua`, override in `after/lsp/` only if the defaults are wrong.

## Conventions

- One plugin per file in `lua/sven/plugins/`, named after the plugin.
- Keymaps for a plugin live in that plugin's spec, not in `core/keymaps.lua`;
  `core/keymaps.lua` is for plugin-independent bindings only.
- Every mapping gets a `desc` — which-key surfaces it.
- Leader is `Space`.

## Plugin lock file

`nvim-pack-lock.json` (vim.pack lockfile) is tracked. After
`:lua vim.pack.update()` + `:write`, commit the diff. `lazy-lock.json` is gone.

## Theme

Gruvbox Dark, medium contrast (`ellisonleao/gruvbox.nvim` in
`lua/sven/plugins/colorscheme.lua`), with `vim.o.background = "dark"` matching
`opt.background` in `lua/sven/core/options.lua`. Palette is shared with the
dotfiles repo — see its `CLAUDE.md` for the hex table.
