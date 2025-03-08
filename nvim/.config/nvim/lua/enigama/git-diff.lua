local M = {
	"sindrets/diffview.nvim",
}

function M.config()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	keymap("n", "<leader>gsr", ":diffget //3<CR>", opts)
	keymap("n", "<leader>gsl", ":diffget //2<CR>", opts)
end

return M
