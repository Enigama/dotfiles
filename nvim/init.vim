let g:tokyonight_style = "night"

lua require "enigama.options"
lua require "enigama.keymaps"
lua require "enigama.plugins"
lua require "enigama.colorscheme"
lua require "enigama.cmp"
lua require "enigama.lsp"
lua require "enigama.telescope"
lua require "enigama.treesitter"
lua require "enigama.autopairs"
lua require "enigama.comment"
lua require "enigama.gitsigns"
lua require "enigama.nvim-tree"
lua require "enigama.lualine"
lua require "enigama.impatient"
lua require "enigama.harpoon"
lua require "enigama.toggleterm"
lua require "enigama.dap"

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup ENIGAMA
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
    "autocmd BufWritePre *.lua Neoformat
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
augroup END
