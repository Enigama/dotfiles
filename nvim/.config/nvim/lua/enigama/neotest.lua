local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		-- general tests
		"vim-test/vim-test",
		"nvim-neotest/neotest-vim-test",
		-- language specific tests
		"haydenmeade/neotest-jest",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-plenary",
		"rcasia/neotest-bash",
		"nvim-neotest/nvim-nio",
		--
		"antoinemadec/FixCursorHold.nvim",
	},
}

function M.config()
	local wk = require("which-key")
	wk.add({
		{ "<leader>tp", ":Neotest summary<cr>", desc = "Test panel" },
		{ "<leader>to", ":Neotest output-panel<cr>", desc = "Test output" },
	})

	---@diagnostic disable: missing-fields
	require("neotest").setup({
		discovery = {
			-- enabled = true,
			root = vim.fn.getcwd(),
		},
		adapters = {
			require("neotest-vitest")({
				filter_dir = function(name, rel_path, root)
					return name ~= "node_modules"
				end,
			}),
			-- require("neotest-vim-test")({
			--     ignore_file_types = { "vim", "lua", "javascript", "typescript" },
			-- }),
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = "custom.jest.config.ts",
				env = { CI = true },
				cwd = function(path)
					return vim.fn.getcwd()
				end,
			}),
		},
	})
end

return M
