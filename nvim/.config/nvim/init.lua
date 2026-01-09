require("enigama.launch")
require("enigama.options")
require("enigama.keymaps")
require("enigama.autocmds")
require("enigama.gh-actions")

spec("enigama.alpha")
-- spec("enigama.extras.fidget")
spec("enigama.extras.flash")
spec("enigama.extras.bqf")
spec("enigama.extras.ufo")
spec("enigama.extras.oil")
spec("enigama.extras.lab")
spec("enigama.extras.colorizer")
--
spec("enigama.colorscheme")
spec("enigama.devicons")
spec("enigama.treesitter")

spec("enigama.miss")
spec("enigama.mason")
spec("enigama.schemastore")
spec("enigama.lspsaga")
spec("enigama.lspconfig")
spec("enigama.cmp")
spec("enigama.mark")
-- Jenkins Integration (moved after which-key)
--spec("enigama.jenkins") -- Commented out to avoid Telescope conflicts
spec("enigama.jira")
spec("enigama.telescope")
spec("enigama.none-ls")
spec("enigama.illuminate")
spec("enigama.cmd")
--
spec("enigama.lazyGit")
spec("enigama.git-diff")
spec("enigama.git-figutive")
spec("enigama.gitsigns")
spec("enigama.remarks")
spec("enigama.octo")
--
spec("enigama.whichkey")
spec("enigama.nvimtree")
spec("enigama.comment")
spec("enigama.lualine")
spec("enigama.harpoon")

spec("enigama.jester")
spec("enigama.neotest")

spec("enigama.smart-splits")
-- spec("enigama.window-picker")

spec("enigama.autopairs")
spec("enigama.session")
spec("enigama.project")
spec("enigama.indentline")
spec("enigama.toggleterm")

-- AI
spec("enigama.copilot")

-- Jenkins Integration
--spec("enigama.jenkins")

require("enigama.lazy")

-- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- tokyonight
vim.cmd([[colorscheme catppuccin-frappe ]])
