local web = require('config.web')

require('lazydev').setup()

-- Inherited by every server configured below.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- `root_markers` alone does NOT gate attachment: a nil root still attaches in
-- single-file mode. Only a root_dir function that conditionally calls `on_dir`
-- keeps a server off entirely. See :h lsp-root_dir.
local function root_dir(fn)
  return function(bufnr, on_dir)
    local root = fn(bufnr)
    if root then
      on_dir(root)
    end
  end
end

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
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

vim.lsp.config('ts_native', {
  cmd = { 'tsc', '--lsp', '-stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  settings = { ['js/ts'] = { maximumHoverLength = 1e6 } },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

vim.lsp.config('oxlint', {
  cmd = { 'oxlint', '--lsp' },
  filetypes = web.ft,
  root_dir = root_dir(web.ox_root),
})

vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = web.ft,
  -- The default linter for every JS/TS project, unless the project is an ox one.
  root_dir = root_dir(function(bufnr)
    if web.ox_root(bufnr) then
      return nil
    end
    return vim.fs.root(bufnr, 'package.json')
  end),
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
  -- Answer the server-initiated requests so they don't error in the log. The
  -- last two keep the server quiet in a package.json project with no eslint
  -- installed -- load bearing now that eslint attaches by default.
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
    format = false, -- prettier/oxfmt own formatting
    run = 'onType',
    nodePath = '',
    onIgnoredFiles = 'off',
    useESLintClass = false,
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
    -- Required, not decorative: the server dereferences these without guarding
    -- (`settings.experimental.useFlatConfig`, `settings.problems.shortenToSingleLine`,
    -- and `rulesCustomizations` is iterated directly). Dropping any of them makes
    -- textDocument/diagnostic fail with a TypeError.
    experimental = { useFlatConfig = vim.NIL }, -- let the server auto-detect
    problems = { shortenToSingleLine = false },
    rulesCustomizations = {},
  },
})

-- Tailwind v4 uses CSS-based config (no tailwind.config.* / postcss.config.*),
-- so fall back to detecting the tailwindcss dependency in package.json. This
-- keeps the server off in non-Tailwind projects while attaching in both v3
-- (config-file) and v4 (CSS-config) projects.
local function tailwind_root(bufnr)
  local root = vim.fs.root(bufnr, {
    'tailwind.config.js',
    'tailwind.config.ts',
    'tailwind.config.mjs',
    'tailwind.config.cjs',
    'postcss.config.js',
    'postcss.config.mjs',
    'postcss.config.cjs',
  })
  if root then
    return root
  end

  local pkg = vim.fs.root(bufnr, 'package.json')
  if not pkg then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, pkg .. '/package.json')
  if not ok then
    return nil
  end

  local decoded, tbl = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not decoded or type(tbl) ~= 'table' then
    return nil
  end

  local deps = vim.tbl_extend('keep', tbl.dependencies or {}, tbl.devDependencies or {})
  return deps.tailwindcss ~= nil and pkg or nil
end

vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
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
  root_dir = root_dir(tailwind_root),
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
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
        templ = 'html',
        htmlangular = 'html',
      },
    },
  },
})

vim.lsp.config('graphql', {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = {
    'graphql',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
  },
  root_dir = root_dir(function(bufnr)
    return vim.fs.root(bufnr, {
      '.graphqlrc',
      '.graphqlrc.json',
      '.graphqlrc.yml',
      'graphql.config.js',
      'graphql.config.yaml',
    })
  end),
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
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

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  root_markers = { '.git', '.bashrc', '.zshrc' },
  settings = {
    bashIde = { globPattern = '**/*@(.sh|.inc|.bash|.command|.zsh)' },
  },
})

vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
    embeddedLanguages = { css = true, javascript = true },
  },
})

vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  settings = {
    css = { validate = true },
    less = { validate = true },
    scss = { validate = true },
  },
})

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json', '.git' },
})

vim.lsp.enable({
  'bashls',
  'cssls',
  'eslint',
  'gopls',
  'graphql',
  'html',
  'jsonls',
  'lua_ls',
  'oxlint',
  'pyright',
  'tailwindcss',
  'ts_native',
})

-- Write every file an LSP rename touched, so the change lands on disk straight
-- away. Delegate the edit itself to the built-in handler.
local apply_rename = vim.lsp.handlers['textDocument/rename']
vim.lsp.handlers['textDocument/rename'] = function(err, result, ctx)
  apply_rename(err, result, ctx)
  if err or not result then
    return
  end

  local uris = vim.tbl_keys(result.changes or {})
  for _, change in ipairs(result.documentChanges or {}) do
    if change.textDocument then
      table.insert(uris, change.textDocument.uri)
    end
  end

  for _, uri in ipairs(uris) do
    local buf = vim.uri_to_bufnr(uri)
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd('silent! update')
      end)
    end
  end

  vim.notify('Renamed and saved ' .. #uris .. ' file(s).')
end
