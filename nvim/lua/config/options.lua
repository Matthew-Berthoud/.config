vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Sensible defaults. Its `basic` block (on by default) covers `undofile`,
-- `mouse`, `number`, `incsearch` and friends, so those are not repeated below.
-- Its `extra_ui` block -- which is what sets `list`/`listchars` -- is off by
-- default, so we still set those ourselves.
require('mini.basics').setup()

vim.o.confirm = true
vim.o.expandtab = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.winborder = 'rounded'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Deferred: touching the system clipboard on startup is slow.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
