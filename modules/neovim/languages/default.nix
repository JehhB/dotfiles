{ config, pkgs, ... }:

{
  imports = [ ./options.nix ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      luasnip
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        runtime."after/plugin/nvim-cmp.lua".source = ./nvim-cmp.lua;
      }
      {
        plugin = nvim-treesitter;
        runtime."after/plugin/nvim-treesitter.lua".source = ./nvim-treesitter.lua;
      }
      {
        plugin = nvim-dap-view;
        runtime."after/plugin/nvim-dap-view.lua".source = ./nvim-dap-view.lua;
      }
      {
        plugin = nvim-dap-virtual-text;
        runtime."after/plugin/nvim-dap-virtual.text".source = ./nvim-dap-virtual-text.lua;
      }
    ];
  };
}
