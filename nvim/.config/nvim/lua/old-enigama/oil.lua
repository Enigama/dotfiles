local status_ok, oil = pcall(require, "oil")
if not status_ok then
	return
end

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

oil.setup({
	float = {
		padding = 2,
		max_width = 60,
		max_height = 20,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
	},
})
