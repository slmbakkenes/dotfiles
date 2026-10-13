# nvim

Personal Neovim configuration. Runs on macOS (Apple Silicon). Part of the
[dotfiles](../../../README.md) as the `nvim` stow package.

## Install

```bash
cd ~/Development/dotfiles
stow nvim   # links ~/.config/nvim
nvim
```

Plugins are managed by the built-in `vim.pack` (nvim 0.12+): first launch
installs everything after a confirmation prompt. LSP is native
(`vim.lsp.enable`) — server binaries are **not** auto-installed; put them on
`$PATH` per the table below. Treesitter parsers compile on demand, so the
tree-sitter CLI and a C compiler must be present.

Leader is `Space` — press it and wait for [which-key](https://github.com/folke/which-key.nvim)
to list what's bound.

## Requirements

Base system:

| Need                         | Install                     |
| ---------------------------- | --------------------------- |
| Neovim ≥ 0.12                | `brew install neovim`       |
| C compiler (treesitter)      | Xcode CLT                   |
| tree-sitter CLI (treesitter) | `brew install tree-sitter-cli` (not npm) |
| `ripgrep`, `fd`              | `brew install ripgrep fd`   |
| Nerd Font                    | `font-iosevka-nerd-font`    |
| [mise](https://mise.jdx.dev) | `brew install mise`         |
| .NET SDK                     | `brew install dotnet-sdk`   |

LSP servers and formatters are managed by mise (activate it in your shell rc:
`eval "$(mise activate zsh)"`):

```bash
mise use -g node@lts \
  aqua:LuaLS/lua-language-server \
  aqua:JohnnyMorganz/StyLua \
  npm:prettier \
  npm:typescript \
  npm:typescript-language-server \
  npm:vscode-langservers-extracted \
  npm:dockerfile-language-server-nodejs \
  "npm:@tailwindcss/language-server" \
  "npm:@angular/language-server" \
  dotnet:csharpier
```

This writes `~/.config/mise/config.toml` — it's tracked in the `mise` package of
[slmbakkenes/dotfiles](https://github.com/slmbakkenes/dotfiles), so it's
`mise install` on the next machine.

A few tools live outside mise:

| Need                      | Install                                              |
| ------------------------- | ---------------------------------------------------- |
| C# LSP (roslyn)           | `dotnet tool install -g roslyn-language-server --prerelease --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json` — a .NET global tool, lands in `~/.dotnet/tools` (must be on `PATH`). This is Microsoft's dev feed with builds several times a day; drop `--source` for the slower-moving nuget.org builds. `--prerelease` is needed either way: no stable version is published. Update: same command with `update` instead of `install`. Not in mise — its dotnet backend only supports one global registry URL |
| `google-java-format`      | `brew install google-java-format` (no mise backend fits) |
| .NET debugging (optional) | bundled — ARM64 netcoredbg comes from a plugin |
| Rust (rust-analyzer, rustfmt, clippy) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh`, then `rustup component add rust-analyzer rustfmt clippy` (rustup, not mise: `after/lsp/rust_analyzer.lua` pins the `~/.cargo/bin` proxy so `rust-toolchain.toml` picks the version) |

jdtls (Java) is installed automatically by nvim-java; dartls ships with the
Flutter SDK.

## Layout

```
init.lua              entry point: core → pack → lsp → local
lua/sven/core/        options + keymaps
lua/sven/pack.lua     vim.pack harness: collects specs, build hooks, setups
lua/sven/lsp.lua      native LSP: capabilities, vim.lsp.enable list,
                      LspAttach keymaps, diagnostics
lua/sven/plugins/     one file per plugin: { src, version?, build?, setup? }
after/lsp/            per-server overrides (win the runtimepath merge)
after/ftplugin/       filetype settings (java, cs, rust)
```

## Theme

Gruvbox Dark, medium contrast, via `ellisonleao/gruvbox.nvim`. Matches the
kitty / starship / btop theming in
[slmbakkenes/dotfiles](https://github.com/slmbakkenes/dotfiles).

## Updating plugins

`:lua vim.pack.update()` — review the confirmation buffer, `:write` to apply
(or `:quit` to discard), then commit the resulting `nvim-pack-lock.json`.
On a fresh machine the lockfile pins every plugin to the committed revision.
