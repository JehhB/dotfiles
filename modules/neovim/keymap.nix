{ config, pkgs, ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>b#<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Explore<cr>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>a";
        action.__raw = "vim.lsp.buf.code_action";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "gl";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      }
    ];
  };
}
