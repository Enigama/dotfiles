autocmd vimenter * colorscheme gruvbox
set termguicolors
set bg=dark
set number
set relativenumber
set spell

set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

call plug#begin()
  " Plebvim lsp Plugins
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Plug 'onsails/lspkind-nvim'
  Plug 'nvim-lua/lsp_extensions.nvim'

  " Neovim Tree shitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'romgrk/nvim-treesitter-context'
  Plug 'lewis6991/spellsitter.nvim'

	Plug 'morhetz/gruvbox'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'tpope/vim-fugitive'

  "Plug 'scrooloose/nerdtree'
  "Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'

  " Git work tree
  Plug 'ThePrimeagen/git-worktree.nvim'

  " telescope requirements...
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'

  " Snippets
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'

  " Harpoon
  Plug 'ThePrimeagen/harpoon'

  Plug 'tpope/vim-surround'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}

  Plug 'simrat39/symbols-outline.nvim'

  " Status line
  Plug 'nvim-lualine/lualine.nvim'

  "---------Development--------------
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'HerringtonDarkholme/yats.vim'
  " Prettier
  Plug 'sbdchd/neoformat'
  " Eslint
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'MunifTanjim/eslint.nvim'
  "---------------------------------

  " Status line
  Plug 'feline-nvim/feline.nvim'
call plug#end()

lua require("enigama")

map <leader>m :NvimTreeToggle<CR>
map <leader>mc :NvimTreeFindFileToggle<CR>
map <leader>mr :NvimTreeRefresh<CR>
"map <leader><Tab> :NERDTreeToggle<CR>
"map <leader>r :NERDTreeRefreshRoot<CR>

vmap <Tab> :><CR>gv
vmap <S-Tab> :<<CR>gv

nmap <Tab> >>
nmap <S-Tab> <<

imap <Tab> <c-t>
imap <S-Tab> <c-d>

nmap <C-Tab> ==

" Harpoon
nnoremap <leader>ha <cmd>lua require('harpoon.mark').add_file()<cr>
nnoremap <leader>hf <cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>
" Harpoon specific file
nnoremap <leader>hh <cmd>lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <leader>hj <cmd>lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <leader>hk <cmd>lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <leader>hl <cmd>lua require("harpoon.ui").nav_file(4)<cr>
" Harpoon find files
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
"?????
nnoremap <leader>vd <cmd>lua require('telescope.builtin').lasp_definition()<cr>

" Window
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>

" Telescope + Git work-tree
nnoremap <Leader>wl <cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>
nnoremap <Leader>wn <cmd>:lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>

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
