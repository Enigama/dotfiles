local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"AndreM222/copilot-lualine",
	},
}

function M.config()
	local icons = require("enigama.icons")

	local hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end

	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn" },
		symbols = { error = " ", warn = " " },
		colored = false,
		update_in_insert = false,
		always_visible = true,
	}

	local diff = {
		"diff",
		colored = false,
		symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- changes diff symbols
		cond = hide_in_width,
	}

	local mode = {
		"mode",
		fmt = function(str)
			return "-- " .. str .. " --"
		end,
	}

	local filetype = {
		"filetype",
		icons_enabled = false,
		icon = nil,
	}

	local branch = {
		"branch",
		icons_enabled = true,
		icon = icons.git.Branch,
	}

	local location = {
		"location",
		padding = 0,
	}

	-- cool function for progress
	local progress = function()
		local current_line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")
		local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
		local line_ratio = current_line / total_lines
		local index = math.ceil(line_ratio * #chars)
		return chars[index]
	end

	local spaces = function()
		return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
	end

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "catppuccin-frappe", --"ntokyonight"
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			ignore_focus = { "NvimTree" },
		},
		sections = {
			lualine_a = { branch, diagnostics },
			lualine_b = { mode },
			lualine_c = { "copilot", "filetype" },
			lualine_d = { diff, spaces, "encoding", filetype },
			lualine_x = { require("auto-session.lib").current_session_name },
			lualine_y = { location },
			lualine_z = { progress },
		},
		extensions = { "quickfix", "man", "fugitive", "nvim-tree" },
	})
end

return M
