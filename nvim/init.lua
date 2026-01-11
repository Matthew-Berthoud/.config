vim.pack.add({
  { src = 'https://github.com/HakonHarnes/img-clip.nvim' },
  { src = 'https://github.com/brianhuster/live-preview.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-mini/mini.extra' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/vague2k/vague.nvim' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
})

vim.lsp.enable({ 'lua_ls', 'ts_ls', 'ruff' })

require('mini.pick').setup()
require('mini.extra').setup()
require('mini.icons').setup()
require('nvim-web-devicons').setup()
require('oil').setup({
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  view_options = {
    show_hidden = true,
  },
  columns = {
    'icon',
    'permissions',
    'size',
    'mtime',
  },
})
require('which-key').setup()
require('which-key').add({
  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  { 'gr', group = '[R]eferences' },
})
require('img-clip').setup()
require('live-preview').setup({
  picker = 'mini.pick',
})

vim.cmd('colorscheme vague')
vim.cmd(':hi statusline guibg=NONE')

vim.g.mapleader = ' '
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.confirm = true
vim.o.cursorcolumn = false
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.winborder = 'rounded'
vim.o.breakindent = true

vim.opt.linebreak = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<cr>', { desc = 'Move focus to the left nvim window or tmux pane' })
vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<cr>', { desc = 'Move focus to the lower nvim window or tmux pane' })
vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<cr>', { desc = 'Move focus to the upper nvim window or tmux pane' })
vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<cr>', { desc = 'Move focus to the right nvim window or tmux pane' })
vim.keymap.set('n', '<c-\\>', ':TmuxNavigatePrevious<cr>', { desc = 'Move focus to previous nvim window or tmux pane' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader><leader>', ':Pick buffers<CR>', { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', ':Pick grep_live<CR>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sh', ':Pick help<CR>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sr', ':Pick resume<CR>', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open Oil [E]xplorer' })
vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = '[G]o to [D]efinition' })

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', '*.c' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- You can set specific colors, or link them to existing groups like 'Title', 'Function', etc.
    vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = '#e06c75', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = '#e5c07b', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = '#98c379', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', { fg = '#61afef', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', { fg = '#c678dd', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', { fg = '#56b6c2', bold = true })
  end,
})

require('conform').setup({
  format_on_save = function()
    return {
      lsp_format = 'fallback',
    }
  end,
  formatters_by_ft = {
    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    vue = { 'prettierd' },
    css = { 'prettierd' },
    scss = { 'prettierd' },
    less = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    yaml = { 'prettierd' },
    markdown = { 'prettierd' },
    graphql = { 'prettierd' },
    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    lua = { 'stylua' },
  },
})

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
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
  group = vim.api.nvim_create_augroup('ts_ls', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars
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

vim.keymap.set('n', '<leader>pc', pack_clean, { desc = '[C]lean Vim [P]ack (remove unused plugins)' })
vim.keymap.set('n', '<leader>pi', '<cmd>PasteImage<cr>', { desc = '[P]aste [I]mage from clipboard' })
vim.keymap.set('n', '<leader>pl', '<cmd>LivePreview close<CR><cmd>LivePreview start<CR>', { desc = '[L]ive[P]review for current file' })
vim.keymap.set('n', '<leader>pr', ':update<CR> :source<CR>', { desc = '[P]lease [R]eload nvim configuration' })
