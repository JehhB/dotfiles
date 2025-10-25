{ pkgs, ... }:
{

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.grapple-nvim ];
    extraConfigLua = ''
      require("grapple").setup({
        scope = "git_branch",
        icons = true,
      })

      vim.keymap.set("n", "<leader>m", "<cmd>Grapple toggle<cr>")
      vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>")

      vim.keymap.set("n", "<leader>j", "<cmd>Grapple select index=1<cr>")
      vim.keymap.set("n", "<leader>k", "<cmd>Grapple select index=2<cr>")
      vim.keymap.set("n", "<leader>l", "<cmd>Grapple select index=3<cr>")
      vim.keymap.set("n", "<leader>;", "<cmd>Grapple select index=4<cr>")

      vim.keymap.set("n", "<leader>J", "<cmd>Grapple cycle_tags next<cr>")
      vim.keymap.set("n", "<leader>K", "<cmd>Grapple cycle_tags prev<cr>")
    '';
  };
}
