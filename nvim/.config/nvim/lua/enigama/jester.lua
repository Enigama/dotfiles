local M = {
	"David-Kunz/jester",
}

function M.config()
	local wk = require("which-key")
	wk.add({
		{"<leader>tl", "<cmd>lua require'jester'.run()<cr>", desc = "Test line" },
		{"<leader>ta", "<cmd>lua require'jester'.run_file()<cr>", desc = "Test file" },
	})
	require("jester").setup({
		cmd = "npm test -t '$result' -- $file",
		terminal_cmd = ":split | terminal",
		dap = { -- debug adapter configuration
			type = "node2",
			request = "launch",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
			args = { "--no-cache" },
			sourceMaps = false,
			protocol = "inspector",
			skipFiles = { "<node_internals>/**/*.js" },
			console = "integratedTerminal",
			port = 9229,
			disableOptimisticBPs = true,
		},
	})
end

return M
