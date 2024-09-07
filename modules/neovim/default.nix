{ config, pkgs, ... } :

{
  imports = [ 
    ./colorscheme
    ./lsp
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
}
