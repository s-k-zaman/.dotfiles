# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration managed as part of a dotfiles repo (stowed via GNU Stow from `~/.dotfiles/nvim/`). Written entirely in Lua, using **lazy.nvim** as the plugin manager.

## Architecture

### Boot sequence (`init.lua` → `lua/core/`)

1. `init.lua` — sets global flags (`COLORSCHEME`, `TRANSPARENT`, `USE_LSP_SAGA`, etc.) then requires `core`
2. `core/init.lua` — bootstraps lazy.nvim, loads `core/options.lua`, then calls `lazy.setup()` with the spec from `core/lazy-nvim-config.lua`
3. `core/lazy-nvim-config.lua` — tells lazy.nvim to import `plugins` and `plugins.lsp` directories
4. `core/keymaps.lua` and `core/autocmds/` — loaded by plugins/core as needed (autocmds currently reference old `config.autocmds` paths — migration in progress)

**Leader key**: Space

### Plugin layout (`lua/plugins/`)

Each file returns a lazy.nvim plugin spec (table or list of tables). Lazy auto-discovers all `lua/plugins/*.lua` and `lua/plugins/lsp/*.lua`.

Key plugin files:
- `snacks/init.lua` — snacks.nvim hub: picker (replaces telescope for most things), dashboard, lazygit, explorer, notifier, toggles
- `autocomplete.lua` — blink.cmp with LuaSnip, ripgrep source
- `formatting.lua` — conform.nvim formatters + custom `:Format` command + optional autoformat on save (off by default: `vim.g.autoformat = false`)
- `lsp/mason.lua` — mason + mason-lspconfig setup, custom `:MasonInstallAll` command with master server/tool list
- `lsp/init.lua` — nvim-lspconfig + live-rename specs, global capabilities via `vim.lsp.config("*")`, `LspAttach` autocmd for keymaps and per-client tweaks
- `colorschems.lua` — colorscheme plugins (rose-pine active by default)

### LSP server settings (`after/lsp/`)

Neovim 0.11+ native per-server config files. Each file (e.g., `lua_ls.lua`, `pyright.lua`) returns a plain config table that Neovim auto-loads and merges with `vim.lsp.config("*")` defaults. Servers with no custom config (marksman, jsonls, gopls, taplo) need no file — mason-lspconfig's `automatic_enable` + nvim-lspconfig defaults handle them.

### Utility modules

- `lua/utils/keymapper.lua` — wrapper `keymap(mode, lhs, rhs, opts)` that auto-wraps string commands in `<cmd>...<CR>`
- `lua/utils/init.lua` — helper functions (string ops, table utils, augroup creator with `zaman_nvim` prefix)
- `lua/utils/plugins.lua` — `has(plugin)` checks if a lazy.nvim plugin is loaded
- `lua/modules/` — custom modules: `ui/` (lualine python venv display), `venv_selector_python/` (custom Python venv detection)

### Custom snippets (`lua/snippets/`)

LuaSnip snippets for `latex.lua` and `notes.lua`, loaded in `autocomplete.lua`.

## Global flags (set in `init.lua`)

These globals control behavior across the config:
- `COLORSCHEME` — active colorscheme name
- `TRANSPARENT` — enables transparent backgrounds
- `Disable_Lsp_Server_Formatting` — disable LSP formatter in favor of conform
- `USE_LSP_SAGA` — auto-disabled on Neovim 0.13+
- `USE_LSPKIND`, `USE_LAZYGIT`, `USE_MINI_TEXT_OBJECTS`, `CONFIG_TAILWIND_IN_LSPCONFIG`

## Conventions

- Autoformat is off by default (`vim.g.autoformat = false`); manual format via `:Format` or `<leader>I`
- Lua files use **stylua** (4-space indent); conform.nvim handles all formatting
- Autocmd groups are prefixed `zaman_nvim` via `require("utils").augroup()`
- The config is mid-migration: `lua/config/` (old) → `lua/core/` (new). Some autocmd requires still reference `config.autocmds.*` paths
