local M = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
}

function M.config()
    -- lspconfig server names (NOT mason package names). `stylua` is a
    -- formatter, not an LSP server, so it lives in mason's ensure_installed
    -- below rather than here.
    local servers = {
        "lua_ls",
        "cssls",
        "html",
        "ts_ls",
        "bashls",
        "jsonls",
        "eslint",
        "pyright",
        "yamlls",
    }

    require("mason").setup({
        ui = {
            border = "rounded",
        },
    })

    require("mason-lspconfig").setup({
        -- v2: `ensure_installed` takes the server list; `automatic_installation`
        -- is a boolean. Passing the list to the boolean field silently skips
        -- installation.
        ensure_installed = servers,
        automatic_installation = true,
        -- v2 defaults `automatic_enable` to true, which calls vim.lsp.enable()
        -- for every server. We already start servers manually in lspconfig.lua's
        -- setup loop (with on_attach/capabilities/settings), so leaving this on
        -- attaches each server twice -> Lspsaga peek_definition opens twice.
        automatic_enable = false,
    })

    -- Non-LSP tooling (formatters/linters) installed via mason directly.
    local registry = require("mason-registry")
    for _, pkg in ipairs({ "stylua" }) do
        if registry.has_package(pkg) and not registry.is_installed(pkg) then
            registry.get_package(pkg):install()
        end
    end
end

return M
