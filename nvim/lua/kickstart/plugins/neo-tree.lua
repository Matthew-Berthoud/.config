-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          '.DS_Store',
          '__pycache__',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
