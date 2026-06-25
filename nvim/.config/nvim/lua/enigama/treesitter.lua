local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- main branch does NOT support lazy-loading
	build = ":TSUpdate",
}

local ensure_installed = {
	"lua",
	"markdown",
	"markdown_inline",
	"bash",
	"python",
	"typescript",
	"tsx",
	"yaml",
}

function M.config()
	local ts = require("nvim-treesitter")

	-- install any parsers we don't have yet
	local installed = require("nvim-treesitter.config").get_installed()
	local missing = vim.tbl_filter(function(p)
		return not vim.tbl_contains(installed, p)
	end, ensure_installed)
	if #missing > 0 then
		ts.install(missing)
	end

	-- enable highlighting + treesitter indentation per buffer
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
			-- skip filetypes without an installed parser (e.g. noice, NvimTree)
			if not lang or not vim.tbl_contains(require("nvim-treesitter.config").get_installed(), lang) then
				return
			end
			if pcall(vim.treesitter.language.add, lang) and pcall(vim.treesitter.start, args.buf, lang) then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})
end

return M
