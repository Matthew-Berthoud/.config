local web = require('config.web')

-- Prettier is the default for every filetype it supports, whether or not the
-- file sits in a project. In an ox project oxfmt replaces it: oxfmt covers the
-- same filetypes (js/ts/jsx/tsx, json, css, scss, less, html, md, yaml, vue,
-- svelte, graphql) with the single exception of astro.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

local function web_fmt(bufnr)
  if web.ox_root(bufnr) then
    return { 'oxfmt' }
  end
  return prettier
end

require('conform').setup({
  -- `lsp_format` still matters for filetypes with no formatter below (go -> gopls).
  format_on_save = { lsp_format = 'fallback', timeout_ms = 1000 },
  formatters_by_ft = {
    astro = prettier, -- oxfmt cannot parse .astro
    bash = { 'shfmt' },
    css = web_fmt,
    graphql = web_fmt,
    html = web_fmt,
    javascript = web_fmt,
    javascriptreact = web_fmt,
    json = web_fmt,
    jsonc = web_fmt,
    less = web_fmt,
    lua = { 'stylua' },
    markdown = web_fmt,
    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    scss = web_fmt,
    sh = { 'shfmt' },
    svelte = web_fmt,
    typescript = web_fmt,
    typescriptreact = web_fmt,
    vue = web_fmt,
    yaml = web_fmt,
    zsh = { 'shfmt' },
  },
  formatters = {
    -- conform's builtin only looks for .oxfmtrc.*; widen it so an oxlint-only
    -- project still resolves to the project root.
    oxfmt = { cwd = require('conform.util').root_file(web.ox_markers) },
    shfmt = { prepend_args = { '-i', '2' } }, -- indent with 2 spaces
  },
})
