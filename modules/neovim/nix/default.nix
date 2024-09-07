{ config, pkgs, ... } :

{
  programs.neovim = {
    extraPackages = with pkgs; [
      nil
    ];
  };

  xdg.configFile."nvim/after/plugin/nix.lua".source = ./nix.lua;
}
