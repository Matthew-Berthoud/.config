local mini_icons = require('mini.icons')
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

vim.cmd('colorscheme vague')
vim.cmd('highlight statusline guibg=NONE')

-- Full-ish path instead of a bare filename, in both active and inactive windows.
local filename = { 'filename', file_status = false, path = 1 }
require('lualine').setup({
  sections = { lualine_a = { filename }, lualine_c = {} },
  inactive_sections = { lualine_a = { filename }, lualine_c = {} },
})

require('mini.extra').setup()
require('mini.pick').setup()
vim.env.RIPGREP_CONFIG_PATH = vim.fn.expand('~/.config/ripgrep/config')

require('nvim-treesitter').setup({})
require('nvim-treesitter').install({
  'bash',
  'css',
  'go',
  'graphql',
  'html',
  'javascript',
  'json',
  'jsx',
  'latex',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'scss',
  'sql',
  'swift',
  'tsx',
  'typescript',
  'yaml',
  'zsh',
})

-- Start treesitter wherever a parser exists, rather than maintaining a second
-- list of filetypes that has to be kept in sync with the parsers above.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

require('autoclose').setup({
  options = { disabled_filetypes = { 'text', 'markdown', 'gitcommit' } },
})
require('nvim-ts-autotag').setup()
require('nvim-surround').setup()
require('ts-comments').setup({
  lang = {
    tsx = { 'typescript', 'tsx' },
    jsx = { 'javascript', 'jsx' },
  },
})

require('render-markdown').setup({
  heading = { backgrounds = { '', '', '', '', '', '' } },
  completions = { lsp = { enabled = true } },
  code = { border = 'thin' },
})
require('img-clip').setup()

require('oil').setup({
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  view_options = { show_hidden = true },
  columns = { 'icon', 'permissions', 'size', 'mtime' },
})

require('which-key').setup()
require('which-key').add({
  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  { 'gr', group = '[R]eferences' },
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

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, 'Jump to next git [c]hange')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, 'Jump to previous git [c]hange')

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'git [s]tage hunk')
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'git [r]eset hunk')
    map('n', '<leader>hD', function()
      gitsigns.diffthis('@')
    end, 'git [D]iff against last commit')

    map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
    map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
    map('n', '<leader>hu', gitsigns.stage_hunk, 'git [u]ndo stage hunk')
    map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
    map('n', '<leader>hb', gitsigns.blame_line, 'git [b]lame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git show [b]lame line')
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, '[T]oggle git show [D]eleted')
  end,
})
