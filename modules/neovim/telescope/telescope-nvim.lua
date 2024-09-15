local telescope = require("telescope.builtin");

require("telescope").load_extension("ui-select");

vim.keymap.set("n", "<C-p>", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.git_files, {})
vim.keymap.set("n", "<leader>rg", telescope.live_grep, {})
vim.keymap.set("n", "<leader>dg", telescope.diagnostics, {})

vim.keymap.set("n", "<leader>ff", function()
  local handle = io.popen("git rev-parse --is-inside-work-tree 3> /dev/null")
  if (handle == nil) then
    telescope.find_files({})
    return
  end


  local result = handle:read("*a")

  handle:close()

  if string.match(result, "true") then
    telescope.git_files({})
  else
    telescope.find_files({})
  end
end)
