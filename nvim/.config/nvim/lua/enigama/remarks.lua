local M = {
    "https://github.com/Enigama/remarks.nvim",
    -- dir = "~/Personal/remarks.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- cmd = { "Remarks", "RemarksAdd", "RemarksAddFull", "RemarksShow", "RemarksInit" },
}

M.config = function()
    local wk = require("which-key")
    wk.add({
        { "<leader>nl", "<cmd>Remarks<cr>",        desc = "List Remarks" },
        { "<leader>na", "<cmd>RemarksAdd<cr>",     desc = "Add Remark" },
        { "<leader>nf", "<cmd>RemarksAddFull<cr>", desc = "Add Remark (Full)" },
        { "<leader>ns", "<cmd>RemarksShow<cr>",    desc = "Show Remarks on Commit" },
    })

    require("remarks").setup()
end

return M
