local M = {
	"neovim/nvim-lspconfig",
	dependencies = {},
}

-- Filter, filterReactDTS https://github.com/nvim-telescope/telescope.nvim/issues/2278
local function filter(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

local function filterReactDTS(value)
	return string.match(value.filename, "react/index.d.ts") == nil
end

local function on_list(options)
	local items = options.items
	if #items > 1 then
		items = filter(items, filterReactDTS)
	end

	vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
	vim.api.nvim_command("cfirst") -- or maybe you want 'copen' instead of 'cfirst'
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition({ on_list = on_list })
	end, opts)

	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	-- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- keymap(bufnr, "n", "<leader>r", "<cmd>Lspsaga rename<CR>", opts)
	keymap(bufnr, "n", "<leader>vd", "<cmd>Lspsaga peek_definition<CR>", opts)

	keymap(bufnr, "n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	keymap(bufnr, "n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)

	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end

function M.config()
	local wk = require("which-key")
	wk.add({
		{ "<leader>z", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
		{ "<leader>lt", "<cmd>Lspsaga outline <cr>", desc = "Outline tags" },
		-- {"<leader>lf",
		-- 	"<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
		-- 	desc = "Format",
		-- },
		{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
		{ "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	})

	-- local lspconfig = require("lspconfig")
	local icons = require("enigama.icons")

	local servers = {
		"lua_ls",
		"cssls",
		"html",
		"ts_ls",
		"eslint",
		"pyright",
		"bashls",
		"jsonls",
		"yamlls",
	}
	local sev = vim.diagnostic.severity

	local default_diagnostic_config = {
		signs = {
			active = true,
			text = {
				[sev.ERROR] = icons.diagnostics.Error,
				[sev.WARN] = icons.diagnostics.Warning,
				[sev.HINT] = icons.diagnostics.Hint,
				[sev.INFO] = icons.diagnostics.Information,
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	-- Nvim 0.12+ built-in stylua LSP uses `stylua --lsp` (StyLua >= 2.2.0). Older binaries error out;
	-- formatting still works via none-ls. Upgrade Mason stylua when the registry ships 2.2+.
	if vim.fn.has("nvim-0.12") == 1 then
		local mason_stylua = vim.fn.stdpath("data") .. "/mason/bin/stylua"
		local exe = vim.fn.executable(mason_stylua) == 1 and mason_stylua or vim.fn.exepath("stylua")
		local supports_lsp = false
		if exe ~= "" and vim.fn.executable(exe) == 1 then
			local ver = vim.fn.system({ exe, "--version" })
			local maj, min = ver:match("stylua%s+(%d+)%.(%d+)")
			maj, min = tonumber(maj), tonumber(min)
			supports_lsp = maj ~= nil and (maj > 2 or (maj == 2 and min >= 2))
		end
		if supports_lsp then
			vim.lsp.config("stylua", {
				cmd = { exe, "--lsp" },
			})
		else
			vim.lsp.enable("stylua", false)
		end
	end

	for _, server in pairs(servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
		}

		local require_ok, settings = pcall(require, "enigama.lspsettings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		-- lspconfig[server].setup(opts)
		vim.lsp.config(server, opts)
		vim.lsp.enable(server)
	end
end

return M
