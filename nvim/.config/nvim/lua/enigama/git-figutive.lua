local M = {
	"tpope/vim-fugitive",
}

function M.config()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	keymap("n", "<leader>gs", ":G <cr>", opts)
	keymap("n", "<leader>gl", ":GcLog <CR>", opts)
end
return M
