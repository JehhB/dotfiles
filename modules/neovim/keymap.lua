vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Explore<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>') 
