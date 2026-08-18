vim.loader.enable()

-- Set explicitly (mini.basics would otherwise set it) so that module load order
-- can never leave a `<leader>` mapping bound to the wrong key.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.plugins')
require('config.options')
require('config.ui')
require('config.completion')
require('config.lsp')
require('config.format')
require('config.autocmds')
require('config.keymaps')
