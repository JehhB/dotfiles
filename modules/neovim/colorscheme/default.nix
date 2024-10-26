{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      rainbow-delimiters-nvim
      {
        plugin = indent-blankline-nvim;
        runtime."after/plugin/indent-blankline.lua".source = ./indent-blankline.lua;
      }
      {
        plugin = gruvbox-material-nvim;
        runtime."after/plugin/gruvbox-material.lua".source = ./gruvbox-material.lua;
      }
      {
        plugin = lualine-nvim;
        runtime."after/plugin/lualine.lua".source = ./lualine.lua;
      }
    ];
  };
}
