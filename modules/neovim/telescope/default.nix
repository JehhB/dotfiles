{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        runtime."after/plugin/telescope-nvim.lua".source = ./telescope-nvim.lua;
      }
      telescope-ui-select-nvim
    ];
  };
}
