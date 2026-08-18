-- Shared detection for the JavaScript/TypeScript toolchain.
--
-- The rule: eslint + prettier + typescript are the defaults everywhere. If a
-- project ships any oxc config, oxlint and oxfmt take over completely and
-- eslint/prettier stay out of it. TypeScript runs either way.
local M = {}

M.ft = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'svelte',
  'astro',
}

M.ox_markers = {
  '.oxlintrc.json',
  '.oxlintrc.jsonc',
  '.oxfmtrc.json',
  '.oxfmtrc.jsonc',
}

---@return string? root Directory of the nearest oxc config, or nil.
function M.ox_root(bufnr)
  return vim.fs.root(bufnr or 0, M.ox_markers)
end

return M
