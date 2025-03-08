local M = {
	"rmagatti/auto-session",
}

function M.config()
	local wk = require("which-key")
	wk.add({
		{"<C-s>", "<cmd>SessionSave<cr>", desc = "Session Save " },
	})
	require("auto-session").setup({
		auto_session_root_dir = "~/nvim-sessions/",
		vim.log.levels.ERROR,
		post_restore_cmds = { "NvimTreeClose" },
		pre_save_cmds = { "NvimTreeClose" },
	})
end

return M
