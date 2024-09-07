{ config, pkgs, ... } :

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      luasnip
      cmp-nvim-lsp
      {
        plugin = nvim-lspconfig;
        runtime."after/plugin/nvim-lspconfig.lua".source = ./nvim-lspconfig.lua;
      }
      {
        plugin = nvim-cmp;
        runtime."after/plugin/nvim-cmp.lua".source = ./nvim-cmp.lua;
      }
    ];
  };
}
