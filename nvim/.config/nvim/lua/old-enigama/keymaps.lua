local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

--[[ keymap("n", "<leader>e", ":Lex 30<cr>", opts) ]]
-- Resize with arrows
keymap("n", "<C-Up>", ":resize +10<CR>", opts)
keymap("n", "<C-Down>", ":resize -10<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -10<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +10<CR>", opts)

-- Navigate buffers
keymap("n", "<A-l>", ":bnext<CR>", opts)
keymap("n", "<A-h>", ":bprevious<CR>", opts)

-- Navigate tabs
keymap("n", "<S-l>", ":tabnext<CR>", opts)
keymap("n", "<S-h>", ":tabprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

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

-- Clear search by /
keymap("n", ",", "<cmd>:noh<cr>", opts)

-- Telescope
-- keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files()<cr>", opts)
-- keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", opts)
-- keymap("n", "<leader>fs", "<cmd>lua require'telescope.builtin'.grep_string()<cr>", opts)
-- keymap("n", "<leader>fr", "<cmd>lua require'telescope.builtin'.resume()<cr>", opts)
-- keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers()<cr>", opts)
-- keymap("n", "<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<cr>", opts)

-- ????Telescope + Git work-tree
keymap("n", "<leader>wl", "<cmd>lua require'telescope'.extensions.git_worktree.git_worktrees()<cr>", opts)
keymap("n", "<leader>wa", "<cmd>lua require'telescope'.extensions.git_worktree.create_git_worktree()<cr>", opts)

-- Harpoon
-- keymap("n", "<s-m>", "<cmd>lua require'harpoon.mark'.add_file()<cr>", opts)
-- keymap("n", "<TAB>", "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>", opts)

-- Harpoon quick movement files
keymap("n", "<leader>hh", "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>", opts)
keymap("n", "<leader>hj", "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>", opts)
keymap("n", "<leader>hk", "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>", opts)
keymap("n", "<leader>hl", "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>", opts)
keymap("n", "<leader>h;", "<cmd>lua require'harpoon.ui'.nav_file(5)<cr>", opts)

-- Nvimtree
keymap("n", "<leader>ee", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>ei", ":NvimTreeFindFileToggle<cr>", opts)
keymap("n", "<leader>er", ":NvimTreeRefresh<cr>", opts)
keymap("n", "<leader>ef", ":NvimTreeFocus<cr>", opts)

-- Git
keymap("n", "<leader>gs", ":G <cr>", opts)
keymap("n", "<leader>gsr", ":diffget //3<CR>", opts)
keymap("n", "<leader>gsl", ":diffget //2<CR>", opts)
keymap("n", "<leader>gl", ":GcLog <CR>", opts)
--[[ keymap("n", "<leader>gcm", ":Git commit <LEFT>", opts) ]]
--[[ keymap("n", "<leader>gc", ":Git checkout <LEFT>", opts) ]]
keymap("n", "<leader>gb", ":G blame<cr>", opts)
-- keymap("n", "<leader>gs", "<cmd>lua require'neogit'.open()<cr>", opts)

-- Gitsigns
keymap("n", "]c", ":Gitsigns next_hunk<CR>", opts)
keymap("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
keymap("n", "<leader>hb", ":Gitsigns toggle_current_line_blame<CR>", opts)
keymap("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", opts)

-- Close quickfix panel
keymap("n", "<leader>q", ":cclose<cr>", opts)

-- Tests
keymap("n", "<leader>tl", "<cmd>lua require'jester'.run()<cr>", opts)
keymap("n", "<leader>ta", "<cmd>lua require'jester'.run_file()<cr>", opts)

-- Neo Test
keymap("n", "<leader>tp", ":Neotest summary<cr>", opts)
keymap("n", "<leader>to", ":Neotest output-panel<cr>", opts)

-- Aerial/Tags
keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", opts)

-- Trouble list
keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", opts)
keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)

-- Collapse HTML blocks
keymap("n", "<leader>ll", "zfat<CR>", opts)

-- Octo
keymap("n", "<leader>pr", ":Octo pr create<CR>", opts)
keymap("n", "<leader>cp", ":Octo pr checks<CR>", opts)
keymap("n", "<leader>pl", ":Octo pr list checks<CR>", opts)

-- Preview definitions
-- keymap("n", "<leader>vd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)
-- keymap("n", "<leader>vr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>", opts)

-- C++
keymap("n", "<leader>cg", ":CMakeGenerate<CR>", opts)
keymap("n", "<leader>cb", ":CMakeBuild<CR>", opts)
-- keymap("n", "<leader>cr", ":CMakeRun<CR>", opts)

-- Flesh search along file and highlight
keymap("n", "s", "<cmd>lua require('flash').jump()<cr>", opts)
keymap("n", "<leader>v", "<cmd>lua require('flash').treesitter()<cr>", opts)
