local M = {
    "sindrets/diffview.nvim",
}

function M.config()
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap("n", "<leader>go", ":diffget //2<CR>", opts) -- Keep ours
    keymap("n", "<leader>gt", ":diffget //3<CR>", opts) -- Accept theirs
    keymap("n", "<leader>gb", ":diffget //1<CR>", opts) -- Use based

    -- Update diff after choosing
    keymap("n", "<leader>du", ":diffupdate<CR>", opts) -- Update diff view
end

return M
