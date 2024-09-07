vim.g.lightline = {
  colorscheme = "gruvbox"
}
vim.api.nvim_create_autocmd({"VimEnter"}, {
  pattern = {"*"},
  command = "call lightline#update()",
})
