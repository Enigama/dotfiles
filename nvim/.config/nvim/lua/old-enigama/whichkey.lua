local status_ok, whichkey = pcall(require, "whichkey")
if not status_ok then
	return
end

local mappings = {
	-- q = { "<cmd>confirm q<CR>", "Quit" },
	-- h = { "<cmd>nohlsearch<CR>", "NOHL" },
	-- [";"] = { "<cmd>tabnew | terminal<CR>", "Term" },
	-- v = { "<cmd>vsplit<CR>", "Split" },
	-- b = { name = "Buffers" },
	-- d = { name = "Debug" },
	-- f = { name = "Find" },
	-- g = { name = "Git" },
	-- l = { name = "LSP" },
	-- p = { name = "Plugins" },
	-- t = { name = "Test" },
	-- w = { name = "Watch" },
	-- a = {
	-- 	name = "Tab",
	-- 	n = { "<cmd>$tabnew<cr>", "New Empty Tab" },
	-- 	N = { "<cmd>tabnew %<cr>", "New Tab" },
	-- 	o = { "<cmd>tabonly<cr>", "Only" },
	-- 	h = { "<cmd>-tabmove<cr>", "Move Left" },
	-- 	l = { "<cmd>+tabmove<cr>", "Move Right" },
	-- },
	-- T = { name = "Treesitter" },
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
}

whichkey.setup({
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
	window = {
		border = "rounded",
		position = "bottom",
		padding = { 2, 2, 2, 2 },
	},
	ignore_missing = true,
	show_help = false,
	show_keys = false,
	disable = {
		buftypes = {},
		filetypes = { "TelescopePrompt" },
	},
})

whichkey.register(mappings, opts)
