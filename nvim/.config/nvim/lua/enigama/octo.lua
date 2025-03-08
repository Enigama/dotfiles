local M = {
	"pwntester/octo.nvim",
}

function M.config()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	keymap("n", "<leader>pr", ":Octo pr create<CR>", opts)
	keymap("n", "<leader>cp", ":Octo pr checks<CR>", opts)
	keymap("n", "<leader>pl", ":Octo pr list checks<CR>", opts)

	require("octo").setup({
		suppress_missing_scope = {
			projects_v2 = true,
		},
	})
end

return M
