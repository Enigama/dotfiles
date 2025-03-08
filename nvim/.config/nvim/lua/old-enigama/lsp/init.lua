local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

-- require 'lspconfig'.ccls.setup {}
require("lspconfig").clangd.setup({})
require("enigama.lsp.mason")
-- require "enigama.lsp.lsp-installer"
require("enigama.lsp.handlers").setup()
require("enigama.lsp.none-ls")
