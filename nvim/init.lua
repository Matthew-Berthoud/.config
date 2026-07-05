vim.loader.enable()

vim.pack.add({
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/folke/ts-comments.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/hakonharnes/img-clip.nvim' },
  { src = 'https://github.com/iamcco/markdown-preview.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/m4xshen/autoclose.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
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

local mini_icons = require('mini.icons')
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

require('luasnip').setup({ enable_autosnippets = true })
require('luasnip.loaders.from_lua').load({
  paths = { vim.fn.stdpath('config') .. '/snippets/' },
})
local ls = require('luasnip')
vim.keymap.set({ 'i', 's' }, '<C-e>', function()
  ls.expand_or_jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-J>', function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-K>', function()
  ls.jump(-1)
end, { silent = true })

require('mini.basics').setup()
require('lazydev').setup()
require('lualine').setup({
  sections = {
    lualine_a = {
      {
        'filename',
        file_status = false,
        path = 1,
      },
    },
    lualine_c = {},
  },
  inactive_sections = {
    lualine_a = {
      {
        'filename',
        file_status = false,
        path = 1,
      },
    },
    lualine_c = {},
  },
})

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

vim.lsp.config('oxlint', {
  cmd = { 'oxlint', '--lsp' },
  capabilities = capabilities,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  root_markers = {
    '.oxlintrc.json',
    '.oxlintrc.jsonc',
    'oxlint.config.ts',
    'oxlint.config.js',
    'oxlint.config.mjs',
  },
})
vim.lsp.enable('oxlint')

vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
  },
  -- The vscode-eslint server needs a workspaceFolder to resolve the project's
  -- eslint install and config; derive it per-buffer from the resolved root.
  before_init = function(_, config)
    if config.root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = vim.uri_from_fname(config.root_dir),
        name = vim.fn.fnamemodify(config.root_dir, ':t'),
      }
    end
  end,
  -- Answer the server-initiated requests so they don't error in the log.
  handlers = {
    ['eslint/openDoc'] = function()
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function()
      return 4 -- always allow
    end,
    ['eslint/probeFailed'] = function()
      return {}
    end,
    ['eslint/noLibrary'] = function()
      return {}
    end,
  },
  settings = {
    validate = 'on',
    useESLintClass = false,
    experimental = { useFlatConfig = vim.NIL }, -- let server auto-detect
    codeActionOnSave = { enable = false, mode = 'all' },
    format = false, -- Prettier/oxfmt own formatting, not ESLint
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
  },
})
vim.lsp.enable('eslint')

vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
      },
      includeLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
        templ = 'html',
        htmlangular = 'html',
      },
    },
  },
  root_markers = {
    'tailwind.config.js',
    'tailwind.config.ts',
    'tailwind.config.mjs',
    'postcss.config.js',
    'package.json',
    '.git',
  },
})
vim.lsp.enable('tailwindcss')

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
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})
vim.lsp.enable('gopls')

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  capabilities = capabilities,
  filetypes = { 'sh', 'bash', 'zsh' },
  root_markers = { '.git', '.bashrc', '.zshrc' },
  settings = {
    bashIde = {
      globPattern = '**/*@(.sh|.inc|.bash|.command|.zsh)',
    },
  },
})
vim.lsp.enable('bashls')

vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = { 'html' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
  },
})
vim.lsp.enable('html')

vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  settings = {
    css = { validate = true },
    less = { validate = true },
    scss = { validate = true },
  },
})
vim.lsp.enable('cssls')

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  capabilities = capabilities,
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
})
vim.lsp.enable('jsonls')

vim.lsp.config('graphql', {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  capabilities = capabilities,
  filetypes = {
    'graphql',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
  },
  root_markers = {
    '.graphqlrc.yml',
    '.graphqlrc',
    '.graphqlrc.json',
    'graphql.config.js',
    'graphql.config.yaml',
    'package.json',
    '.git',
  },
})
vim.lsp.enable('graphql')

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
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'bash',
    'css',
    'go',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsx',
    'latex',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'react',
    'scss',
    'sql',
    'swift',
    'tsx',
    'typescript',
    'typescriptreact',
    'yaml',
    'zsh',
  },
  callback = function()
    vim.treesitter.start()
  end,
})

require('autoclose').setup({
  options = { disabled_filetypes = { 'text', 'markdown', 'gitcommit' } },
})
require('nvim-ts-autotag').setup()
require('nvim-surround').setup()
require('mini.extra').setup()
require('mini.pick').setup()
vim.env.RIPGREP_CONFIG_PATH = vim.fn.expand('~/.config/ripgrep/config')
require('ts-comments').setup({
  lang = {
    tsx = {
      'typescript',
      'tsx',
    },
    jsx = {
      'javascript',
      'jsx',
    },
  },
})
vim.cmd('colorscheme vague')
require('render-markdown').setup({
  heading = {
    backgrounds = { '', '', '', '', '', '' },
  },
  completions = { lsp = { enabled = true } },
  code = { border = 'thin' },
})

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

-- markdown-preview setup:
vim.fn['mkdp#util#install']()
vim.keymap.set('n', '<leader>b', '<cmd>MarkdownPreview<CR>')

vim.cmd(':hi statusline guibg=NONE')

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
vim.keymap.set('n', '<leader>bx', function()
  -- 1. Create a table to keep track of buffers currently visible in any window
  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_bufs[vim.api.nvim_win_get_buf(win)] = true
  end
  local closed_count = 0
  -- 2. Iterate over all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- 3. Check if it's loaded, not visible, and a "listed" buffer
    if vim.api.nvim_buf_is_loaded(buf) and not visible_bufs[buf] then
      if vim.bo[buf].buflisted then
        -- 4. Attempt to delete gracefully (won't close buffers with unsaved changes)
        local success, _ = pcall(vim.api.nvim_buf_delete, buf, { force = false })
        if success then
          closed_count = closed_count + 1
        end
      end
    end
  end
  vim.notify('Closed ' .. closed_count .. ' hidden buffers', vim.log.levels.INFO)
end, { desc = 'Close [X] all hidden listed [B]uffers' })

vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open Oil [E]xplorer' })
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)
vim.keymap.set('n', '<leader>sf', ':Pick files<CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', ':Pick grep_live<CR>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sm', ':Pick marks<CR>', { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sh', ':Pick help<CR>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sG', function()
  local glob = vim.fn.input('Include glob (prefix ! to exclude): ')
  require('mini.pick').builtin.grep_live({
    globs = glob ~= '' and { glob } or nil,
  })
end, { desc = '[S]earch by [G]rep in files matching [G]lob' })
vim.keymap.set('n', '<leader>sr', ':Pick resume<CR>', { desc = '[S]earch [R]esume' })
vim.keymap.set(
  'n',
  'grd',
  '<cmd>lua vim.lsp.buf.definition()<CR>',
  { desc = '[G]o to [R]eal [D]efinition' }
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
  -- wrap text in non-code situations
  pattern = { 'text', 'markdown', 'gitcommit', 'qf' },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.breakindent = true
    vim.wo.showbreak = '↳ '
  end,
})

-- Run the attached linter's fix-all on save before conform formats (registered
-- before conform.setup so its BufWritePre runs first). buf_request_sync blocks
-- until the server applies its edits, guaranteeing fix-then-format ordering.
-- Whichever linter LSP is attached (oxlint in oxlint projects, eslint in eslint
-- projects) drives its own fix-all command. The LSP round-trip is only worth it
-- when that linter actually reported something, so clean saves (the common case)
-- skip it entirely and just run the formatter.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.vue', '*.svelte', '*.astro' },
  callback = function(args)
    local linter
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if c.name == 'oxlint' or c.name == 'eslint' then
        linter = c
        break
      end
    end
    if not linter then
      return
    end
    local flagged = false
    for _, d in ipairs(vim.diagnostic.get(args.buf)) do
      if d.source == linter.name then
        flagged = true
        break
      end
    end
    if not flagged then
      return
    end
    local uri = vim.uri_from_bufnr(args.buf)
    local cmd, cmd_args
    if linter.name == 'oxlint' then
      cmd, cmd_args = 'oxc.fixAll', { { uri = uri } }
    else
      cmd, cmd_args =
        'eslint.applyAllFixes', { { uri = uri, version = vim.lsp.util.buf_versions[args.buf] } }
    end
    vim.lsp.buf_request_sync(args.buf, 'workspace/executeCommand', {
      command = cmd,
      arguments = cmd_args,
    }, 1000)
  end,
})

-- Web filetypes: try Prettier first (only runs where configured), else oxfmt.
local web_fmt = { 'prettierd', 'prettier', 'oxfmt', stop_after_first = true }

require('conform').setup({
  format_on_save = function()
    return {
      lsp_format = 'fallback',
    }
  end,
  formatters_by_ft = {
    -- Prefer Prettier when the project configures it (require_cwd below), else
    -- fall back to oxfmt. stop_after_first runs whichever comes first.
    javascript = web_fmt,
    javascriptreact = web_fmt,
    typescript = web_fmt,
    typescriptreact = web_fmt,
    vue = web_fmt,
    css = web_fmt,
    scss = web_fmt,
    less = web_fmt,
    html = web_fmt,
    json = web_fmt,
    yaml = web_fmt,
    markdown = web_fmt,
    graphql = web_fmt,
    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    lua = { 'stylua' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
  },
  formatters = {
    -- Only run Prettier when a Prettier config is found; otherwise it is skipped
    -- and oxfmt (the fallback) runs.
    prettierd = { require_cwd = true },
    prettier = { require_cwd = true },
    shfmt = {
      -- prepends these args to the command
      prepend_args = { '-i', '2' }, -- indent with 2 spaces
    },
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
  '<leader>pr',
  ':update<CR> :source ~/.config/nvim/init.lua<CR>',
  { desc = '[P]lease [R]eload nvim configuration' }
)

-- Force save all buffers after an LSP rename
-- Place this at the end of your init.lua
vim.lsp.handlers['textDocument/rename'] = function(err, result, ctx)
  -- 1. Error handling
  if err then
    vim.notify('Rename error: ' .. err.message, vim.log.levels.ERROR)
    return
  end
  if not result then
    return
  end

  -- 2. Apply the edits (standard Neovim behavior)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

  -- 3. Identify all affected files and save them
  local uris = {}

  -- Gather URIs from standard 'changes' map
  if result.changes then
    for uri, _ in pairs(result.changes) do
      table.insert(uris, uri)
    end
  end

  -- Gather URIs from 'documentChanges' (used by some LSPs)
  if result.documentChanges then
    for _, change in ipairs(result.documentChanges) do
      if change.textDocument then
        table.insert(uris, change.textDocument.uri)
      end
    end
  end

  -- 4. Loop through files and force save
  for _, uri in ipairs(uris) do
    local bufnr = vim.uri_to_bufnr(uri)
    -- If the buffer is valid (loaded by the edit), save it
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('update')
      end)
    end
  end

  -- Optional: Notify the user
  vim.notify('Renamed and saved ' .. #uris .. ' file(s).', vim.log.levels.INFO)
end
