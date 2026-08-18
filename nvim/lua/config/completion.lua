local ls = require('luasnip')

ls.setup({ enable_autosnippets = true })
require('luasnip.loaders.from_lua').load({
  paths = { vim.fn.stdpath('config') .. '/snippets/' },
})

vim.keymap.set({ 'i', 's' }, '<C-e>', function()
  ls.expand_or_jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-J>', function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-K>', function()
  ls.jump(-1)
end, { silent = true })

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'show', 'select_next', 'fallback' },
    ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = { enabled = true },
})
