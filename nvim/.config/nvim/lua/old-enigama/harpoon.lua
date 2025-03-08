local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
	return
end

local wk = require("which-key")
wk.register({
	["<s-m>"] = { "<cmd>lua require'harpoon.mark'.add_file()<cr>", "Watch File" },
	["<TAB>"] = { "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>", "Watch Files" },
})

harpoon.setup()
