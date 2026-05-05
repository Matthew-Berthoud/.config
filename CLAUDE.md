# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal macOS dotfiles. Configs live in `~/.config/<tool>/` and are applied system-wide via `scripts/sync.sh` (`dotsync` alias), which symlinks zsh/git configs to `~/`, runs `brew bundle --clean`, and applies macOS defaults.

## Key Commands

```bash
dotsync              # apply all changes (symlinks, brew, macOS defaults)
brew bundle --clean  # sync Homebrew packages from Brewfile
```

## Architecture

- **Brewfile** — source of truth for all installed packages and apps
- **zsh/.zshenv** — defines `$CONFIG`, `$SCRIPTS`, `$WORK_REPOS`, `$WORKFLOW` used throughout scripts
- **nvim/init.lua** — single-file Neovim config using `vim.pack` (not lazy.nvim); LSP servers installed via Brewfile + `scripts/version_managers/nvm_npm.sh`
- **git/.gitconfig** — includes `git/.gitconfig-work` conditionally via `gitdir:` when inside `~/repos/black-cape`
- **scripts/sync.sh** — main orchestrator; zsh and git configs need symlinking, everything else in `~/.config/` is read directly by tools
