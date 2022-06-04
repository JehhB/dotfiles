" Plugins
call plug#begin()
    " Eye Candy plugins
    Plug 'itchyny/lightline.vim'
    Plug 'morhetz/gruvbox'

    " FZF plugins
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Conquer of Completion plugins
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'clangd/coc-clangd', {'do': 'npm ci'}
    Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}

    " Nerd tree plugin 
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

    " Misc plugin
    Plug 'tpope/vim-dispatch'
    Plug 'preservim/nerdcommenter'
call plug#end()

" Enable filetype plugins
filetype plugin on

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

" Lightline setttings
if !has('gui_running')
    set t_Co=256
endif
autocmd VimEnter * call lightline#update()

set laststatus=2
set noshowmode
set background=dark
let g:lightline={'colorscheme': 'gruvbox'}

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

nnoremap <silent> K :call ShowDocumentation(1)<CR>

function! ShowDocumentation(showManual)
  try
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    elseif  a:showManual
      call feedkeys('K', 'in')
    endif
  catch
    echo "coc.nvim not ready yet"
  endtry
endfunction

set updatetime=750
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHold * silent call ShowDocumentation(0)

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

set signcolumn=number

command! -nargs=0 Format :call CocActionAsync('format')
let g:coc_snippet_next='<tab>'

" FZF setting
nnoremap <silent> <C-p> :Files<CR>

" Nerdtree settings
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif " Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | "If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeGitStatusIndicatorMapCustom={
    \ 'Modified'  :'✹',
    \ 'Staged'    :'✚',
    \ 'Untracked' :'✭',
    \ 'Renamed'   :'➜',
    \ 'Unmerged'  :'═',
    \ 'Deleted'   :'✖',
    \ 'Dirty'     :'✗',
    \ 'Ignored'   :'☒',
    \ 'Clean'     :'✔︎',
    \ 'Unknown'   :'?',
\ }
let g:NERDTreeGitStatusUseNerdFonts=1

" Nerd commenter settings
let g:NERDDefaultAlign='left'
