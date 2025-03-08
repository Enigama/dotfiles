local M = {
	"catppuccin/nvim",
	name = "catppuccin",
	-- "folke/tokyonight.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
}

function M.config()
	-- require("tokyonight").setup({
	-- 	style = "tokyonight-storm",
	-- })
    require("catppuccin").setup({
        transparent_background = true,
        integrations = {
            fidget = true
        }
    })
end

return M
