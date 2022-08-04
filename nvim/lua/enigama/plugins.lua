require('feline').setup()
require("nvim-tree").setup({
  diagnostics = {
    enable = true
  }
})
require('spellsitter').setup()
require('lualine').setup({options = { theme = 'gruvbox' }})

