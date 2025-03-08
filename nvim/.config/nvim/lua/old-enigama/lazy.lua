local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath) -- My plugins here

vim.g.mapleader = " "

local plugins = {
	"nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
	"nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
	"windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
	--  "numToStr/Comment.nvim" -- Easily comment stuff
	"folke/todo-comments.nvim",
	"tpope/vim-commentary",
	-- Smooth scroll behavior(Ctr-d,u)
	"opalmay/vim-smoothie",
	-- "petertriho/nvim-scrollbar", -- Scroll bar shows where you are
	"christianchiarulli/nvim-ts-autotag",
	"kyazdani42/nvim-web-devicons",
	"kyazdani42/nvim-tree.lua",
	"stevearc/oil.nvim", -- Add/remove multiple files
	--Session
	"rmagatti/auto-session",
	"folke/which-key.nvim",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "AndreM222/copilot-lualine" },
	},
	"lewis6991/impatient.nvim",
	"akinsho/toggleterm.nvim",
	-- Like go to back and forward for files that were oppened
	-- "ghillb/cybu.nvim",
	"folke/trouble.nvim",

	--Floating cmd
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	--  'rcarriga/nvim-notify'

	--Show preview of nullls,lsp, formatting in right bottom screen
	{
		"j-hui/fidget.nvim",
	},
	--Search along the file
	{
		"folke/flash.nvim",
	},
	-- "ggandor/lightspeed.nvim",
	--  {
	--     "ggandor/leap.nvim",
	--     config = function() require("leap").set_default_keymaps() end
	--
	--Navigate through line by f/F with highlight
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
				dim = true,
			})
		end,
	},
	"MattesGroeger/vim-bookmarks",

	--Testing plugin
	{
		"0x100101/lab.nvim",
		build = "cd js && npm ci",
	},
	"David-Kunz/jester",
	{
		"nvim-neotest/neotest",
		dependencies = {
			"haydenmeade/neotest-jest",
			"antoinemadec/FixCursorHold.nvim",
		},
	},

	--Floating cmp-cmdline, play with options, now looks bad especially when  split window
	--  {
	--   'VonHeikemen/fine-cmdline.nvim',
	--   dependencies = {
	--     {'MunifTanjim/nui.nvim'}
	--   }
	-- }
	-- Colorscheme
	--  "marko-cerovac/material.nvim"
	"folke/tokyonight.nvim",
	--  "tomasiser/vim-code-dark"
	"norcalli/nvim-colorizer.lua",

	-- cmp plugins
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",

	-- snippets
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/nvim-lsp-installer", -- simple to use language server installer
	"williamboman/mason.nvim",
	{ "williamboman/mason-lspconfig.nvim" },
	{ "nvimtools/none-ls.nvim" }, -- for formatters and linters
	{ "RRethy/vim-illuminate" },
	{ "nvimdev/lspsaga.nvim" },

	-- Formating
	"sbdchd/neoformat",

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	"nvim-telescope/telescope-media-files.nvim",

	-- Tags
	"stevearc/aerial.nvim",

	-- Harpoon
	"ThePrimeagen/harpoon",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	-- "nvim-treesitter/playground",
	"p00f/nvim-ts-rainbow",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"nvim-treesitter/nvim-treesitter-context", -- for fix function at the top of the screen

	-- Git
	"lewis6991/gitsigns.nvim",
	-- "ThePrimeagen/git-worktree.nvim",
	"tpope/vim-fugitive",
	--  "TimUntersberger/neogit"
	"sindrets/diffview.nvim",

	-- Debuging
	{ "mfussenegger/nvim-dap" },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
	},
	{ "theHamsta/nvim-dap-virtual-text" },
	--  { "puremourning/vimspector" }

	-- Quickfix bar
	"kevinhwang91/nvim-bqf",

	-- Spell
	-- 'shinglyu/vim-codespell',

	-- Time management
	--  'wakatime/vim-wakatime'

	-- Bad habbits
	"m4xshen/hardtime.nvim",

	-- GH PR plugins
	--  "vim-denops/denops.vim"
	--  "skanehira/denops-gh.vim"
	{
		"pwntester/octo.nvim",
		config = function()
			require("octo").setup()
		end,
	},

	"rmagatti/goto-preview",
	--  {
	--     'mrded/nvim-lsp-notify',
	--     config = function()
	--         require('lsp-notify').setup({})
	--     end
	-- }

	-- Indents
	"lukas-reineke/indent-blankline.nvim",

	-- C
	"cdelledonne/vim-cmake",

	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		dependencies = { "zbirenbaum/copilot-cmp" },
	},
}
require("lazy").setup(plugins, {})
