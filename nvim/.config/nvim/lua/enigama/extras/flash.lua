local M = {
	"folke/flash.nvim",
	event = "VeryLazy",
}

function M.config()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }
	keymap("n", "s", "<cmd>lua require('flash').jump()<cr>", opts)
	-- keymap("n", "<leader>v", "<cmd>lua require('flash').treesitter()<cr>", opts)
	require("flash").setup({})
end

return M
