local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

require("tokyonight").setup({
	style = "storm",
})
-- require("material").setup({
--   lualine_style = 'default'
-- })
