local M = {
  "folke/which-key.nvim",
    dependencies = {
        "echasnovski/mini.icons"
    }
}

function M.config()
  -- local mappings = {
    -- q = { "<cmd>confirm q<CR>", desc = "Quit" },
  --   h = { "<cmd>nohlsearch<CR>", desc = "NOHL" },
  --   v = { "<cmd>vsplit<CR>", desc = "Split" },
  --   b = { name = "Buffers" },
  --   d = { name = "Debug" },
  --   f = { name = "Find" },
  --   g = { name = "Git" },
  --   l = { name = "LSP" },
  --   p = { name = "Plugins" },
  --   t = { name = "Test" },
  --   a = {
  --     name = "Tab",
  --     n = { "<cmd>$tabnew<cr>", desc = "New Empty Tab" },
  --     N = { "<cmd>tabnew %<cr>", desc = "New Tab" },
  --     o = { "<cmd>tabonly<cr>", desc = "Only" },
  --     h = { "<cmd>-tabmove<cr>", desc = "Move Left" },
  --     l = { "<cmd>+tabmove<cr>", desc = "Move Right" },
  --   },
  --   T = { name = "Treesitter" },
  -- }

  local which_key = require "which-key"
  which_key.setup {
    triggers = {
      { "<leader>", mode = "n" },
    },
    spec = {
      mode = { "n", "v" }, -- NORMAL and VISUAL mode
      { "<leader>q", "<cmd>confirm q <CR>", desc = "Quit" }, -- no need to specify mode since it's inherited
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    win = {
      --border = "rounded",
      --position = "bottom",
      title = true,
      padding = { 2, 2, 2, 2 },
    },
    -- ignore_missing = true,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  }
  -- which_key.add(mappings)
end

return M
