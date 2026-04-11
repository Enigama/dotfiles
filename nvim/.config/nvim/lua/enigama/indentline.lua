local M = {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = { "BufReadPost", "BufNewFile" },
}

function M.config()
	local icons = require("enigama.icons")

	require("ibl").setup({
		indent = { char = icons.ui.LineMiddle },
		whitespace = {
			remove_blankline_trail = true,
		},
		exclude = {
			filetypes = {
				"help",
				"startify",
				"dashboard",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"Trouble",
				"text",
			},
			buftypes = { "terminal", "nofile" },
		},
		scope = {
			enabled = true,
			char = icons.ui.LineMiddle,
		},
	})
end

return M
