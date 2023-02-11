local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require "enigama.lsp.mason"
-- require "enigama.lsp.lsp-installer"
require("enigama.lsp.handlers").setup()
require "enigama.lsp.null-ls"
