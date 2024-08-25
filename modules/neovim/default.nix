{ config, pkgs, ... } :

{
  programs.neovim = {
  	enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      git
      curl
      nil
    ];

    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];
  };

  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };
}
