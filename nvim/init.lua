vim.loader.enable()

vim.pack.add({
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/brianhuster/live-preview.nvim' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/gaoDean/autolist.nvim' },
  { src = 'https://github.com/hakonharnes/img-clip.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/m4xshen/autoclose.nvim' },
  { src = 'https://github.com/nvim-mini/mini.basics' },
  { src = 'https://github.com/nvim-mini/mini.extra' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/vague2k/vague.nvim' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
})

local mini_icons = require('mini.icons')
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

require('mini.basics').setup()
require('lazydev').setup()

local blink = require('blink.cmp')
blink.setup({
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'show', 'select_next', 'fallback' },
    ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  fuzzy = {
    implementation = 'lua',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = { enabled = true },
})
local capabilities = blink.get_lsp_capabilities()

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  capabilities = capabilities,
  filetypes = { 'lua' },
  root_markers = { '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    },
  },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = {
    'typescript',
    'typescriptreact',
    'javascript',
    'javascriptreact',
  },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  init_options = {
    preferences = {
      includeInlayParameterNameHints = 'all',
      includeInlayFunctionParameterTypeHints = true,
      importModuleSpecifierPreference = 'non-relative',
    },
  },
})
vim.lsp.enable('ts_ls')

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  capabilities = capabilities,
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
})
vim.lsp.enable('pyright')

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  capabilities = capabilities,
  filetypes = { 'go', 'gomod', 'gowork' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})
vim.lsp.enable('gopls')

require('nvim-treesitter').setup()
require('nvim-treesitter').install({
  'lua',
  'tsx',
  'typescript',
  'html',
  'javascript',
  'css',
  'scss',
  'python',
  'go',
  'swift',
  'markdown',
  'markdown_inline',
  'bash',
  'latex',
  'yaml',
  'sql',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'lua',
    'tsx',
    'typescript',
    'html',
    'javascript',
    'css',
    'scss',
    'python',
    'go',
    'swift',
    'markdown',
    'markdown_inline',
    'bash',
    'latex',
    'yaml',
    'sql',
  },
  callback = function()
    vim.treesitter.start()
  end,
})

require('autoclose').setup()
require('nvim-ts-autotag').setup()
require('nvim-surround').setup()
require('mini.extra').setup()
require('mini.pick').setup()
vim.cmd('colorscheme vague')
require('render-markdown').setup({
  heading = {
    backgrounds = { '', '', '', '', '', '' },
  },
  completions = { lsp = { enabled = true } },
  code = { border = 'thin' },
})
require('autolist').setup()

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

vim.cmd(':hi statusline guibg=NONE')

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.confirm = true
vim.o.expandtab = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.o.mouse = 'a'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.undofile = true
vim.o.winborder = 'rounded'

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.keymap.set('i', '<tab>', '<cmd>AutolistTab<cr>')
vim.keymap.set('i', '<s-tab>', '<cmd>AutolistShiftTab<cr>')
-- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
vim.keymap.set('i', '<CR>', '<CR><cmd>AutolistNewBullet<cr>')
vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>')
vim.keymap.set('n', 'O', 'O<cmd>AutolistNewBulletBefore<cr>')
vim.keymap.set('n', '<CR>', '<cmd>AutolistToggleCheckbox<cr><CR>')
vim.keymap.set('n', '<C-r>', '<cmd>AutolistRecalculate<cr>')

-- cycle list types with dot-repeat
vim.keymap.set('n', '<leader>cn', require('autolist').cycle_next_dr, { expr = true })
vim.keymap.set('n', '<leader>cp', require('autolist').cycle_prev_dr, { expr = true })

-- if you don't want dot-repeat
-- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
-- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

-- functions to recalculate list on edit
vim.keymap.set('n', '>>', '>><cmd>AutolistRecalculate<cr>')
vim.keymap.set('n', '<<', '<<<cmd>AutolistRecalculate<cr>')
vim.keymap.set('n', 'dd', 'dd<cmd>AutolistRecalculate<cr>')
vim.keymap.set('v', 'd', 'd<cmd>AutolistRecalculate<cr>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set(
  'n',
  '<c-\\>',
  ':TmuxNavigatePrevious<cr>',
  { desc = 'Move focus to previous nvim window or tmux pane' }
)
vim.keymap.set(
  'n',
  '<c-h>',
  ':TmuxNavigateLeft<cr>',
  { desc = 'Move focus to the left nvim window or tmux pane' }
)
vim.keymap.set(
  'n',
  '<c-j>',
  ':TmuxNavigateDown<cr>',
  { desc = 'Move focus to the lower nvim window or tmux pane' }
)
vim.keymap.set(
  'n',
  '<c-k>',
  ':TmuxNavigateUp<cr>',
  { desc = 'Move focus to the upper nvim window or tmux pane' }
)
vim.keymap.set(
  'n',
  '<c-l>',
  ':TmuxNavigateRight<cr>',
  { desc = 'Move focus to the right nvim window or tmux pane' }
)
vim.keymap.set('n', '<leader><leader>', ':Pick buffers<CR>', { desc = '[ ] Find existing buffers' })
vim.keymap.set(
  'n',
  '<leader>bd',
  ':bp | bd #<CR>',
  { desc = '[D]elete [B]uffer but preserve split' }
)
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open Oil [E]xplorer' })
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', ':Pick grep_live<CR>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sh', ':Pick help<CR>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sr', ':Pick resume<CR>', { desc = '[S]earch [R]esume' })
vim.keymap.set(
  'n',
  'grd',
  '<cmd>lua vim.lsp.buf.definition()<CR>',
  { desc = '[G]o to [D]efinition' }
)

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

vim.api.nvim_create_autocmd('FileType', {
  -- have to re-enforce these since neovim reeeeally wants you using 4 space indent for markdown
  pattern = 'markdown',
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
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

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'git [r]eset hunk' })
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
    map(
      'n',
      '<leader>tb',
      gitsigns.toggle_current_line_blame,
      { desc = '[T]oggle git show [b]lame line' }
    )
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
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

vim.keymap.set(
  'n',
  '<leader>pc',
  pack_clean,
  { desc = '[C]lean Vim [P]ack (remove unused plugins)' }
)
vim.keymap.set(
  'n',
  '<leader>pi',
  '<cmd>PasteImage<cr>',
  { desc = '[P]aste [I]mage from clipboard' }
)
vim.keymap.set(
  'n',
  '<leader>pl',
  '<cmd>LivePreview close<CR><cmd>LivePreview start<CR>',
  { desc = '[L]ive[P]review for current file' }
)
vim.keymap.set(
  'n',
  '<leader>pr',
  ':update<CR> :source ~/.config/nvim/init.lua<CR>',
  { desc = '[P]lease [R]eload nvim configuration' }
)
