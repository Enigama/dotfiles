local M = {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		debug = false,
		sources = {
			formatting.stylua,
			formatting.prettier.with({
				extra_filetypes = { "github-actions-workflow" },
			}), -- null_ls.builtins.completion.spell,
		},

		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
						-- vim.lsp.buf.formatting_sync()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end

return M
