local conform = require('conform')

local slow_format_filetypes = {}
conform.setup({
  formatters_by_ft = {
    angular = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    svelte = { "prettier" },
    twig = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    yaml = { "prettier" },
  },
  format_on_save = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    local function on_format(err)
      if err and err:match("timeout$") then
        slow_format_filetypes[vim.bo[bufnr].filetype] = true
      end
    end

    return { timeout_ms = 200, lsp_fallback = true }, on_format
  end,

  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    return { lsp_fallback = true }
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
  conform.format({
    lsp_fallback = true,
    timeout_ms = 1500,
  })
end)
