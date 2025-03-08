local M = {
    "mrjones2014/smart-splits.nvim",
}

function M.config()
    require("smart-splits").setup()
end

return M
