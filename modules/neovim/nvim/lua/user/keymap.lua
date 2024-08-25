vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Explore<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true })
