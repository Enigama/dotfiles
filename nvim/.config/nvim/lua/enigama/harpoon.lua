local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<s-m>", "<cmd>lua require('enigama.harpoon').mark_file()<cr>", opts)
  keymap("n", "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
  keymap("n", "<leader>hh", "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>", opts)
  keymap("n", "<leader>hj", "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>", opts)
  keymap("n", "<leader>hk", "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>", opts)
  keymap("n", "<leader>hl", "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>", opts)
  keymap("n", "<leader>h;", "<cmd>lua require'harpoon.ui'.nav_file(5)<cr>", opts)
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

return M
