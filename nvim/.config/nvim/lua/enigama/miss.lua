local M = {
	"Enigama/miss.nvim",
	-- dir = "~/Personal/miss.nvim",
}

function M.config()
	require("miss").setup()
end

return M
