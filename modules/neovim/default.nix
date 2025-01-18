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

  home.packages = with pkgs; [
    ripgrep
    fzf
    ripgrep-all
    wl-clipboard
  ];

  nvim-config.allLanguages.grammars = true;
  nvim-config.allLanguages.formatters = true;
  nvim-config.languages = {
    astro.enable = true;
    css.enable = true;
    emmet.enable = true;
    html.enable = true;
    htmldjango.enable = true;
    json.enable = true;
    nix.enable = true;
    python.enable = true;
    typescript.enable = true;
  };
}
