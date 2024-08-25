require 'nvim-treesitter.configs'.setup {
  modules = {},
  ignore_install = {},

  ensure_installed = {
    "angular",
    "c",
    "cpp",
    "css",
    "glsl",
    "html",
    "javascript",
    "lua",
    "php",
    "python",
    "query",
    "sql",
    "tsx",
    "twig",
    "typescript",
    "vim",
    "vimdoc",
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
}

vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
  pattern = { "*.component.html", "*.page.html" },
  callback = function()
    vim.bo.filetype = "angular"
  end
});
