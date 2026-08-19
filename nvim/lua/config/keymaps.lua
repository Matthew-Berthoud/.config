local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight')

-- Move between nvim windows and tmux panes with the same keys.
map('n', '<c-\\>', '<cmd>TmuxNavigatePrevious<CR>', 'Move focus to previous window or pane')
map('n', '<c-h>', '<cmd>TmuxNavigateLeft<CR>', 'Move focus to the left window or pane')
map('n', '<c-j>', '<cmd>TmuxNavigateDown<CR>', 'Move focus to the lower window or pane')
map('n', '<c-k>', '<cmd>TmuxNavigateUp<CR>', 'Move focus to the upper window or pane')
map('n', '<c-l>', '<cmd>TmuxNavigateRight<CR>', 'Move focus to the right window or pane')

map('n', '<leader><leader>', '<cmd>Pick buffers<CR>', '[ ] Find existing buffers')
map('n', '<leader>e', '<cmd>Oil<CR>', 'Open Oil [E]xplorer')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

map('n', '<leader>sf', '<cmd>Pick files<CR>', '[S]earch [F]iles')
map('n', '<leader>sg', '<cmd>Pick grep_live<CR>', '[S]earch by [G]rep')
map('n', '<leader>sm', '<cmd>Pick marks<CR>', '[S]earch [M]arks')
map('n', '<leader>sh', '<cmd>Pick help<CR>', '[S]earch [H]elp')
map('n', '<leader>sr', '<cmd>Pick resume<CR>', '[S]earch [R]esume')
map('n', '<leader>sG', function()
  local glob = vim.fn.input('Include glob (prefix ! to exclude): ')
  require('mini.pick').builtin.grep_live({ globs = glob ~= '' and { glob } or nil })
end, '[S]earch by [G]rep in files matching [G]lob')

map('n', 'grd', vim.lsp.buf.definition, '[G]o to [R]eal [D]efinition')
map('n', '<leader>lf', function()
  -- Matches source.fixAll.eslint and source.fixAll.oxc alike -- code action
  -- kinds are hierarchical, so the prefix covers both linters.
  vim.lsp.buf.code_action({ context = { only = { 'source.fixAll' } }, apply = true })
end, '[L]int [F]ix all')

map('n', '<leader>bd', '<cmd>bp | bd #<CR>', '[D]elete [B]uffer but preserve split')
map('n', '<leader>bx', function()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end

  local closed = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not visible[buf] and vim.bo[buf].buflisted then
      -- Won't close buffers with unsaved changes, which is the point.
      if pcall(vim.api.nvim_buf_delete, buf, { force = false }) then
        closed = closed + 1
      end
    end
  end

  vim.notify('Closed ' .. closed .. ' hidden buffers')
end, 'Close [X] all hidden listed [B]uffers')

map('n', '<leader>pc', require('config.plugins').clean, '[C]lean Vim [P]ack (remove unused)')
map('n', '<leader>pi', '<cmd>PasteImage<CR>', '[P]aste [I]mage from clipboard')
map('n', '<leader>pr', function()
  -- `require` caches, so the config modules have to be dropped before sourcing.
  for name in pairs(package.loaded) do
    if name:match('^config%.') then
      package.loaded[name] = nil
    end
  end
  vim.cmd('update | source ' .. vim.fn.stdpath('config') .. '/init.lua')
  vim.notify('Reloaded nvim configuration.')
end, '[P]lease [R]eload nvim configuration')
map('n', '<leader>pu', vim.pack.update, '[U]pdate Vim [P]ack')
