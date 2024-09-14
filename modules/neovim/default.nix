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

  nvim-config.languages = {
    clang.enable = true;
    css.enable = true;
    emmet.enable = true;
    glsl.enable = true;
    nix.enable = true;
    html.enable = true;
    php.enable = true;
    tailwindcss.enable = true;
    lua.enable = true;
    typescript.enable = true;
    vue.enable = true;
  };
}
