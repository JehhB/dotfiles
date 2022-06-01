" Plugins
call plug#begin()
    Plug 'itchyny/lightline.vim'
    Plug 'morhetz/gruvbox'

    " Conquer of Completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'clangd/coc-clangd', {'do': 'npm ci'}
    Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
call plug#end()

" Mouse support
set mouse=a

" Set tab as space
set tabstop=4 expandtab
set shiftwidth=4

" Line numbers
set number relativenumber

" Terminal settings
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen,BufEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
tnoremap <C-n> <C-\><C-n>

" Set where to put new splits
set splitbelow splitright

" Lightline setttings
if !has('gui_running')
    set t_Co=256
endif

set laststatus=2
set noshowmode
set background=dark
let g:lightline = {'colorscheme': 'gruvbox'}

" Colorscheme
if has('termguicolors')
    set termguicolors
endif

set background=dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_better_performance=1
let g:gruvbox_italic=1

colorscheme gruvbox

" CoC settings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

set signcolumn=number

command! -nargs=0 Format :call CocActionAsync('format')
let g:coc_snippet_next = '<tab>'
