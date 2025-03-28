local M = {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"zbirenbaum/copilot-cmp",
	},
}

function M.config()
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "<c-s>", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

	require("copilot").setup({
		panel = {
			keymap = {
				jump_next = "<c-j>",
				jump_prev = "<c-k>",
				accept = "<c-l>",
				refresh = "r",
				open = "<M-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<c-l>",
				next = "<c-j>",
				prev = "<c-k>",
				dismiss = "<c-h>",
			},
		},
		filetypes = {
			markdown = true,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node",
	})
end

return M
