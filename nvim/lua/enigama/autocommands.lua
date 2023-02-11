vim.cmd [[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
    augroup END

    " augroup ENIGAMA
    "     autocmd!
    "     autocmd BufWritePre * undojoin | Neoformat
    "     "autocmd BufWritePre *.lua Neoformat
    "     autocmd BufWritePre * %s/\s\+$//e
    "     autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
    " augroup END
]]
