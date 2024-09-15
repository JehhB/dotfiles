vim.o.spelllang = "en_us"
vim.o.spell = true

vim.o.secure = true
vim.o.exrc = true

vim.cmd("filetype plugin on")

vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

vim.o.wildmenu = true
vim.o.wildmode = "longest,list,full"
vim.o.wildignore = vim.o.wildignore .. "**/node_modules/*,**/.git/*,"
vim.o.signcolumn = "number"

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.number = true
vim.o.relativenumber = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.hlsearch = false
vim.o.incsearch = true

--vim.o.t_Co = 256
vim.o.laststatus = 2
vim.o.showmode = false
