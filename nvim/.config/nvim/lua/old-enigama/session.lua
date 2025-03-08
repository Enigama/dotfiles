local status_ok, session = pcall(require, "auto-session")
if not status_ok then
	return
end

local wk = require("which-key")
wk.register({
	["<C-s>"] = { "<cmd>SessionSave<cr>", "Session Save " },
})

-- Restore tree, without it would be working incorrect
local function change_nvim_tree_dir()
	local nvim_tree = require("nvim-tree")
	nvim_tree.change_dir(vim.fn.getcwd())
end

session.setup({
	auto_session_root_dir = "~/nvim-sessions/",
	vim.log.levels.ERROR,
	post_restore_cmds = { "NvimTreeClose" },
	pre_save_cmds = { "NvimTreeClose" },
})
