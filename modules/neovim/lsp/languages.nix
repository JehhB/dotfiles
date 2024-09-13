{ config, lib, pkgs, ... }:

let
  cfg = config.nvim-config.languages;
  defaultLanguages = import ./default-languages.nix { inherit pkgs; };

  languageOptions = { name, config, ... }: {
    options = {
      enable = lib.mkEnableOption "Enable support for ${name}";
      treesitterGrammars = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.anything);
        default = defaultLanguages.${name}.treesitterGrammars or (p: [ p.${name} ]);
        description = "Function to select TreeSitter grammars for ${name}";
      };
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = defaultLanguages.${name}.extraPackages or [];
        description = "Extra packages to install for ${name} (e.g., LSP)";
      };
      extraPlugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = defaultLanguages.${name}.extraPlugins or [];
        description = "Extra Neovim plugins for ${name}";
      };
      extraLuaConfig = lib.mkOption {
        type = lib.types.lines;
        default = defaultLanguages.${name}.extraLuaConfig or "";
        description = "Extra Neovim configuration for ${name}";
      };
      lspConfig = lib.mkOption {
        type = lib.types.lines;
        default = defaultLanguages.${name}.lspConfig or "";
        description = "LSP configuration for ${name}";
      };
    };
  };

  enabledLanguages = lib.filterAttrs (name: lang: lang.enable) cfg;

in {
  options.nvim-config.languages = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule languageOptions);
    default = {};
    description = "Language-specific configurations for Neovim";
  };

  config = {
    programs.neovim = {
      plugins = lib.concatMap (lang: lang.extraPlugins) (lib.attrValues enabledLanguages) ++ [
        {
          plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            p: lib.concatMap (lang: lang.treesitterGrammars p) (lib.attrValues enabledLanguages)
          ));
          runtime."after/plugin/nvim-treesitter.lua".source = ./nvim-treesitter.lua; 
        }
        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          runtime."after/plugin/nvim-lspconfig.lua".text = ''
          ${builtins.readFile ./nvim-lspconfig.lua}

          local lspconfig = require('lspconfig')
          local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: lang: lang.lspConfig) enabledLanguages)}
          '';
        }
        pkgs.vimPlugins.playground
      ];
      extraPackages = lib.concatMap (lang: lang.extraPackages) (lib.attrValues enabledLanguages);
      extraLuaConfig = ''
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: lang: lang.extraLuaConfig) enabledLanguages)}
      '';
    };

  };
}
