{ config, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        runtime."after/plugin/telescope-nvim.lua".source = ./telescope-nvim.lua;
      }
      (telescope-fzf-native-nvim.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.gnumake
          pkgs.gcc
        ];
        buildPhase = "make";
      }))
      telescope-ui-select-nvim
    ];
  };
}
