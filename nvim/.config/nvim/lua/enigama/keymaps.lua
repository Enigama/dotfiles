local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-i>", "<C-i>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- keymap("n", "<C-tab>", "<c-6>", opts)???

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "p", [["_dP]])

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- more good
keymap({ "n", "o", "x" }, "<s-h>", "^", opts)
keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +10<CR>", opts)
keymap("n", "<C-Down>", ":resize -10<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -10<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +10<CR>", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Clear search by ,
keymap("n", ",", "<cmd>:noh<cr>", opts)

vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)

keymap("n", "<leader>P", ":Alpha<CR>", opts)

-- Sort selected lines by length
vim.keymap.set("v", "<leader>sl", function()
	-- 1. Exit visual mode to update the '< and '> marks
	-- 'true' and 'false' arguments handle the escape sequence
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

	-- 2. Get the positions
	local start_pos = vim.fn.getpos("'<")[2]
	local end_pos = vim.fn.getpos("'>")[2]

	-- 3. Normalize: ensure start_line is the minimum (handles bottom-to-top selection)
	local start_line = math.min(start_pos, end_pos)
	local end_line = math.max(start_pos, end_pos)

	-- 4. Get the lines (start_line - 1 because nvim_buf_get_lines is 0-indexed)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- 5. Sort the table by string length
	table.sort(lines, function(a, b)
		return #a < #b
	end)

	-- 6. Put the sorted lines back
	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { desc = "Sort selection by line length" })

-- Quickfix better navigation
keymap("n", "]q", "<cmd>cnext<cr>zz")
keymap("n", "[q", "<cmd>cprev<cr>zz")
