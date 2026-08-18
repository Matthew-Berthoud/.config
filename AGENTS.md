# AGENTS.md

This file provides guidance to LLM Agents when working with code in this repository.

Personal macOS dotfiles. Configs live in `~/.config/<tool>/` and are applied system-wide via `scripts/sync.sh` (`dotsync` alias), which symlinks zsh/git configs to `~/`, runs `brew bundle --clean`, and applies macOS defaults.

## Key Commands

```bash
dotsync              # apply all changes (symlinks, brew, macOS defaults)
brew bundle --clean  # sync Homebrew packages from Brewfile
```

## Architecture

- **Brewfile** — source of truth for all installed packages and apps
- **zsh/.zshenv** — defines `$CONFIG`, `$SCRIPTS`, `$WORK_REPOS`, `$WORKFLOW` used throughout scripts
- **nvim/** — Neovim config using `vim.pack` (not lazy.nvim). `init.lua` sets the leader key and requires `nvim/lua/config/*.lua` in a fixed order: `plugins` → `options` → `ui` → `completion` → `lsp` → `format` → `autocmds` → `keymaps`. The order matters — `options` calls `mini.basics.setup()` before overriding its options, and `completion` sets up blink.cmp before `lsp` reads its capabilities. LSP servers are installed via Brewfile + `scripts/version_managers/nvm_npm.sh`
- **JS/TS toolchain** — eslint + prettier + typescript are the default everywhere (root marker: `package.json`; prettier needs no project at all). If a project ships any oxc config (`.oxlintrc.*` / `.oxfmtrc.*`, see `nvim/lua/config/web.lua`), oxlint and oxfmt take over completely and eslint/prettier are held back; typescript runs either way. `ts_ls` drops its unused-symbol diagnostics (`ignoredCodes`) so the linter is the only thing reporting them
- **git/.gitconfig** — includes `git/.gitconfig-work` conditionally via `gitdir:` when inside `~/repos/black-cape`
- **scripts/sync.sh** — main orchestrator; zsh and git configs need symlinking, everything else in `~/.config/` is read directly by tools
