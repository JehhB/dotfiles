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
    astro.enable = true;
    clang.enable = true;
    css.enable = true;
    emmet.enable = true;
    html.enable = true;
<<<<<<< HEAD
=======
    htmldjango.enable = true;
>>>>>>> de95b82 (Added html django)
    json.enable = true;
    mdx.enable = true;
    nix.enable = true;
    python.enable = true;
    tailwindcss.enable = true;
    typescript.enable = true;
    vue.enable = true;
    yaml.enable = true;
  };
}
