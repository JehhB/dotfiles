{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = rainbow-delimiters-nvim;
        config = ''
          require('rainbow-delimiters.setup').setup()
        '';
        type = "lua";
      }
      {
        plugin = nvim-colorizer-lua;
        config = ''
          require 'colorizer'.setup()
        '';
        type = "lua";
      }
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
