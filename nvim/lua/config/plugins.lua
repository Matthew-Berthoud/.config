vim.pack.add({
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/folke/ts-comments.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/hakonharnes/img-clip.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/m4xshen/autoclose.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-mini/mini.basics' },
  { src = 'https://github.com/nvim-mini/mini.extra' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  -- Pinned to release tags: blink only publishes the prebuilt Rust fuzzy-matching
  -- binary per tag, so tracking the branch head silently falls back to the slow
  -- Lua matcher.
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1.0') },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/vague2k/vague.nvim' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
})

local M = {}

-- Delete plugins still on disk that are no longer listed above. `active` is
-- false for anything vim.pack knows about but this session never added.
function M.clean()
  local unused = {}
  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      table.insert(unused, plugin.spec.name)
    end
  end

  if #unused == 0 then
    vim.notify('No unused plugins.', vim.log.levels.INFO)
    return
  end

  local prompt = 'Remove ' .. table.concat(unused, ', ') .. '?'
  if vim.fn.confirm(prompt, '&Yes\n&No', 2) == 1 then
    vim.pack.del(unused)
  end
end

return M
