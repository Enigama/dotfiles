local M = {}
local api = vim.api

-- Function to prettify the type
local function prettify_type(type)
    return "Prettify<" .. type .. ">"
end

-- Function to show the interface shape in a preview window using vim.notify
function M.show_interface_shape()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cword>")

    -- Trigger the hover request to the LSP server
    local params = {
        textDocument = {
            uri = vim.uri_from_bufnr(0),
        },
        position = {
            line = vim.fn.line(".") - 1,
            character = vim.fn.col(".") - 1,
        },
    }

    vim.lsp.buf_request(0, "textDocument/hover", params, function(_, _, result)
        if result and result.contents then
            -- Extract the interface shape from the hover result
            local contents = result.contents
            local interface_shape = contents.value:gsub("interface%s-" .. word .. "%s-{|(.+)|}%s-$", "%1")

            -- Prettify the interface shape
            local prettified_shape = prettify_type(interface_shape)

            -- Show the prettified shape in a preview window using vim.notify
            vim.notify(prettified_shape, "info", { title = "Interface Shape" })
        end
    end)
end

-- Set up the key mapping to trigger the interface shape preview
vim.api.nvim_set_keymap('n', '<leader>i', ':lua require("enigama.interface-preview").show_interface_shape()<CR>',
    { noremap = true, silent = true })

return M

