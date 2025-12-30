vim.pack.add({
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-mini/mini.extra' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/vague2k/vague.nvim' },
})

require('mini.pick').setup()
require('mini.extra').setup()
require('oil').setup({
  view_options = {
    show_hidden = true,
  },
})

vim.cmd('colorscheme vague')
vim.cmd(':hi statusline guibg=NONE')

vim.g.mapleader = ' '
vim.o.clipboard = 'unnamedplus'
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.signcolumn = 'yes'
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.winborder = 'rounded'
vim.o.wrap = false

-- vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>') -- enable when editing this file a lot
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader> ', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>l', '<cmd>LivePreview close<CR><cmd>LivePreview start<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>')
vim.keymap.set('n', '<leader>sg', ':Pick grep<CR>')
vim.keymap.set('n', '<leader>sl', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>sl', ':Pick resume<CR>')

vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action)
vim.keymap.set('n', 'grr', function()
  require('mini.extra').pickers.lsp({ scope = 'references' })
end)
vim.keymap.set('n', 'gri', function()
  require('mini.extra').pickers.lsp({ scope = 'implementation' })
end)
vim.keymap.set('n', 'grd', function()
  require('mini.extra').pickers.lsp({ scope = 'definition' })
end)
vim.keymap.set('n', 'grD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gO', function()
  require('mini.extra').pickers.lsp({ scope = 'document_symbol' })
end)
vim.keymap.set('n', 'gW', function()
  require('mini.extra').pickers.lsp({ scope = 'workspace_symbol' })
end)
vim.keymap.set('n', 'grt', function()
  require('mini.extra').pickers.lsp({ scope = 'type_definition' })
end)

vim.keymap.set('n', '\\', function()
  if vim.bo.filetype == 'oil' then
    require('oil').close()
  else
    require('oil').open()
  end
end, { desc = 'Toggle Oil' })

require('mason').setup()

require('mason-tool-installer').setup({
  ensure_installed = {
    'prettierd',
    'prettier',
    'stylua',
    'ts_ls',
    'eslint',
    'lua_ls',
  },
})

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      local success, config = pcall(require, 'lsp.' .. server_name)
      if not success then
        config = {}
      end
      require('lspconfig')[server_name].setup(config)
    end,
  },
})

require('conform').setup({
  format_on_save = function()
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
  },
})

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis('@')
    end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.cmd('set completeopt+=noselect')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local function pack_clean()
  local active_plugins = {}
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    active_plugins[plugin.spec.name] = plugin.active
  end

  for _, plugin in ipairs(vim.pack.get()) do
    if not active_plugins[plugin.spec.name] then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print('No unused plugins.')
    return
  end

  local choice = vim.fn.confirm('Remove unused plugins?', '&Yes\n&No', 2)
  if choice == 1 then
    vim.pack.del(unused_plugins)
  end
end

vim.keymap.set('n', '<leader>pc', pack_clean)
