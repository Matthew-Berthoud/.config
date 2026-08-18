-- Languages that want 4-space (or hard-tab) indentation instead of the default 2.
for _, indent in ipairs({
  { pattern = 'go', expandtab = false, width = 4 },
  { pattern = { 'c', 'python' }, expandtab = true, width = 4 },
}) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = indent.pattern,
    callback = function()
      vim.opt_local.expandtab = indent.expandtab
      vim.opt_local.shiftwidth = indent.width
      vim.opt_local.tabstop = indent.width
      vim.opt_local.softtabstop = indent.width
    end,
  })
end

-- Wrap text in non-code situations.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'text', 'markdown', 'gitcommit', 'qf' },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.breakindent = true
    vim.wo.showbreak = '↳ '
  end,
})
