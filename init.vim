set nocompatible              " be iMproved, required
filetype off                  " required
autocmd vimenter * colorscheme gruvbox

call plug#begin()
" The following are examples of different formats supported.
" plugin on GitHub repo
Plug 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plug 'L9'
" Git plugin not hosted on GitHub
" Plug 'git://git.wincent.com/command-t.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plug 'ascenator/L9', {'name': 'newL9'}

"My plugins list
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

Plug 'morhetz/gruvbox'

Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'

Plug 'yggdroot/indentline'

" Plug 'gorodinskiy/vim-coloresque'

Plug 'mattn/emmet-vim'
Plug 'marijnh/tern_for_vim'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'preservim/nerdcommenter'
" Plug 'joom/vim-commentary'

Plug 'francoiscabrol/ranger.vim'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
"Plug 'majutsushi/tagbar'

"show language on airline, only Linux
Plug 'lyokha/vim-xkbswitch'

"Translate, need to install https://github.com/soimort/translate-shell 
Plug 'echuraev/translate-shell.vim', { 'do': 'wget -O ~/.config/nvim/trans git.io/trans && chmod +x ~/.config/nvim/trans' }

"not workin width coc(
"Plug 'Shougo/deoplete.nvim'
" All of your Plugs must be added before the following line
call plug#end()
" required

filetype plugin indent on    " required
"Set my commands
:let mapleader = ' '
map <F1> :

let g:javascript_plugin_jsdoc = 1

set number "show number line

let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.so'
let g:XkbSwitchIMappings = ['ru']

let g:trans_bin = "~/.config/nvim"

set omnifunc=syntaxcomplete#Complete
let g:user_emmet_leader_key = ','

let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.whitespace = "!"

let g:ft = ''
fu! NERDCommenter_before()
  if &ft == 'vue'
      let g:ft = 'vue'
      let stack = synstack(line('.'), col('.'))
      if len(stack) > 0
          let syn = synIDattr((stack)[0], 'name')
          if len(syn) > 0
              let syn = tolower(syn)
              exe 'setf '.syn
          endif
      endif
  endif
endfu
fu! NERDCommenter_after()
  if g:ft == 'vue'
      setf vue
      let g:ft = ''
  endif
endfu

let NERDTreeShowHidden=1
map <leader><Tab> :NERDTreeToggle<CR>
map <leader><silent>r :NERDTreeRefreshRoot<CR>

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-css',
    \]

" Enable to see non-printable chars
" set list
set autoread
set updatetime=500
au CursorHold * silent! checktime
au FocusLost * silent! wa

set virtualedit=onemore
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set incsearch
set hlsearch
set smartcase
set ignorecase
set backspace=indent,eol,start

"Tab settigns
set shiftwidth=2 tabstop=2 softtabstop=2 expandtab

"set unnamedclip
"set clipboard+=unnamedplus

vmap <Tab> :><CR>gv
vmap <S-Tab> :<<CR>gv

nmap <Tab> >>
nmap <S-Tab> <<

imap <Tab> <c-t>
imap <S-Tab> <c-d>

nmap <C-Tab> ==

noremap <C-0> <C-i>

" Better page up-down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

"Better split navigaton
"example alt + {hjkl, all arrow}
noremap <M-h>  <C-w>h
noremap <M-j>  <C-w>j
noremap <M-k>  <C-w>k
noremap <M-l>  <C-w>l

map <M-Right> <c-w>l
map <M-Left> <c-w>h
map <M-Up> <c-w>k
map <M-Down> <c-w>j

"Find file
map <C-f> :FZF<CR>
map <C-p> :GFiles<CR>

"Find text in file
map <leader>a :Ack<space>'<LEFT>'

"Git short cut
nmap <leader>gs :G <CR>
nmap <leader>gr :diffget //3<CR>
nmap <leader>gl :diffget //2<CR>
nmap <leader>gc :Git commit -m '[FRONT]<space><LEFT>'
nmap <leader>gcb :Git checkout 

"Ranger
"nmap <leader>r :<C-u>Ranger<CR>

"Prettier
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <leader>q :CocCommand prettier.formatFile <CR>

command! W :w

let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](\.git|log|node_modules|coverage|tmp)$',
\ 'file': '\v\.(exe|so|dll|log|pid)$',
\ }

"coc options
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
     \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Fis file width eslint
nnoremap <silent> qf :<C-u>CocCommand eslint.executeAutofix<CR>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"map <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR> */
"coc end


" helpers keys
" <left>         Carriage
" <BS>           Backspace
" <Tab>          Tab
" <CR>           Enter
" <Enter>        Enter
" <Return>       Enter
" <Esc>          Escape
" <Space>        Space
" <Up>           Up arrow
" <Down>         Down arrow
" <Left>         Left arrow
" <Right>        Right arrow
" <F1> - <F12>   Function keys 1 to 12
" #1, #2..#9,#0  Function keys F1 to F9, F10
" <Insert>       Insert
" <Del>          Delete
" <Home>         Home
" <End>          End
" <PageUp>       Page-Up
" <PageDown>     Page-Down
" <bar>          the '|' character, which otherwise needs to be escaped '\|'
