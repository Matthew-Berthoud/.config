vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("mini.pick").setup()
require("oil").setup()
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require 'gitsigns'

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal { ']c', bang = true }
			else
				gitsigns.nav_hunk 'next'
			end
		end, { desc = 'Jump to next git [c]hange' })

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal { '[c', bang = true }
			else
				gitsigns.nav_hunk 'prev'
			end
		end, { desc = 'Jump to previous git [c]hange' })

		-- Actions
		-- visual mode
		map('v', '<leader>hs', function()
			gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
		end, { desc = 'git [s]tage hunk' })
		map('v', '<leader>hr', function()
			gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
		end, { desc = 'git [r]eset hunk' })
		-- normal mode
		map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
		map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
		map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
		map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
		map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
		map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
		map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
		map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
		map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
		-- Toggles
		map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
		map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
	end,
})

vim.g.mapleader = " "
vim.o.clipboard = 'unnamedplus'
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.signcolumn = "yes"
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>lf', function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end
})

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.cmd("set completeopt+=noselect")

vim.lsp.config['lua_ls'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			format = {
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
					quote_style = "AutoPreferSingle",
				}
			}
		}
	}
}

vim.lsp.config['ts_ls'] = {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "typescript.tsx", "typescript.jsx" },
	init_options = {
		preferences = {
			maximumHoverLength = 1e6,
		},
	},
}


vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
