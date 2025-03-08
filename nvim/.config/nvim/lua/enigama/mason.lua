local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
}

function M.config()
	local servers = {
		"lua_ls",
		"cssls",
		"html",
		"ts_ls",
		"bashls",
		"jsonls",
		"stylua",
	}

	require("mason").setup({
		ui = {
			border = "rounded",
		},
	})

	require("mason-lspconfig").setup({
		automatic_installation = servers,
	})
end

return M
