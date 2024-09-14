{ config, pkgs, ... }:

{
  imports = [ ./languages.nix ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      luasnip
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        runtime."after/plugin/nvim-cmp.lua".source = ./nvim-cmp.lua;
      }
    ];
  };
}
