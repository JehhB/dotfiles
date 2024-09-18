{ config, pkgs, ... }:

{
  imports = [
    ./lsp
    ./colorscheme
    ./telescope
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    extraLuaConfig = ''
      ${builtins.readFile ./set.lua}
      ${builtins.readFile ./keymap.lua}
    '';
  };

  nvim-config.allLanguages.grammars = true;
  nvim-config.allLanguages.formatters = true;
  nvim-config.languages = {
    nix.enable = true;
    python.enable = true;
  };
}
