# nvim

Personal Neovim configuration. Runs on macOS and Arch Linux.

## Install

```bash
git clone git@github.com:slmbakkenes/nvim.git ~/.config/nvim
nvim
```

Plugins are managed by the built-in `vim.pack` (nvim 0.12+): first launch
installs everything after a confirmation prompt. LSP is native
(`vim.lsp.enable`) — server binaries are **not** auto-installed; put them on
`$PATH` per the table below. Treesitter parsers compile on demand, so a C
compiler must be present.

Leader is `Space` — press it and wait for [which-key](https://github.com/folke/which-key.nvim)
to list what's bound.

## Requirements

Base system:

| Need                      | macOS                        | Arch                       |
| ------------------------- | ---------------------------- | -------------------------- |
| Neovim ≥ 0.12             | `brew install neovim`        | `pacman -S neovim`         |
| C compiler (treesitter)   | Xcode CLT                    | `pacman -S base-devel`     |
| `ripgrep`, `fd`           | `brew install ripgrep fd`    | `pacman -S ripgrep fd`     |
| Nerd Font                 | `font-iosevka-nerd-font`     | `ttf-iosevka-nerd`         |
| [mise](https://mise.jdx.dev) | `brew install mise`       | `pacman -S mise`           |
| .NET SDK                  | `brew install dotnet-sdk`    | `pacman -S dotnet-sdk`     |

LSP servers and formatters are managed by mise (activate it in your shell rc:
`eval "$(mise activate zsh)"`), one command on both OSes:

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

This writes `~/.config/mise/config.toml` — commit that to dotfiles and it's
`mise install` on the next machine.

A few tools live outside mise:

| Need                      | Install                                              |
| ------------------------- | ---------------------------------------------------- |
| C# LSP (roslyn)           | `dotnet tool install -g roslyn-language-server --prerelease --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json` (custom feed — mise's dotnet backend only supports one global registry URL) |
| `google-java-format`      | `brew install google-java-format` / AUR (jar + wrapper, no mise backend fits) |
| .NET debugging (optional) | bundled ARM64 netcoredbg on macOS; `pacman -S netcoredbg` on Arch |
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
after/ftplugin/       filetype settings (java, cs, kotlin, rust)
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

`:lua vim.pack.update()` — review the confirmation buffer, `:write` to apply
(or `:quit` to discard), then commit the resulting `nvim-pack-lock.json`.
On a fresh machine the lockfile pins every plugin to the committed revision.
