set runtimepath+=/root/.local/share/nvim/site

" Plugins
call plug#begin()
  " Conquer of Completion plugins
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Misc plugin
  Plug 'tpope/vim-dispatch'
  Plug 'preservim/nerdcommenter'
call plug#end()

" Set spellchecking
set spelllang=en_us spell

" Disable search highlighting
set nohlsearch

" Mouse support
set mouse=a

" Selection menu
set wildmenu
set wildmode=longest,list,full
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

" Set tab as space
set expandtab
set shiftwidth=2 tabstop=2

" Line numbers
set number relativenumber

" Terminal settings
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen,BufEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
tnoremap <C-n> <C-\><C-n>

" Set where to put new splits
set splitbelow splitright

" CoC settings
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-toml',
  \ 'coc-snippets',
\ ]

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col=col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)

nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

set signcolumn=number

command! -nargs=0 Format :call CocActionAsync('format')
let g:coc_snippet_next='<tab>'

" Nerd commenter settings
let g:NERDDefaultAlign='left'
