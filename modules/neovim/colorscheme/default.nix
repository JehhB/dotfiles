{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox-nvim;
        runtime."after/plugin/gruvbox.lua".source = ./gruvbox.lua;
      }
      {
        plugin = lightline-vim;
        runtime."after/plugin/lightline.lua".source = ./lightline.lua;
      }
    ];
  };
}
