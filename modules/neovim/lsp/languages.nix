{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nvim-config.languages;
  enabledAll = config.nvim-config.allLanguages.enable;
  allGrammars = config.nvim-config.allLanguages.grammars;
  allFormatters = config.nvim-config.allLanguages.formatters;
  defaultLanguages = import ./default-languages.nix { inherit config lib pkgs; };

  languageOptions =
    { name, config, ... }:
    let
      pluginWithConfigType = lib.types.submodule {
        options = {
          config = lib.mkOption {
            type = lib.types.nullOr lib.types.lines;
            description = "Script to configure this plugin. The scripting language should match type.";
            default = null;
          };

          type = lib.mkOption {
            type = lib.types.either (lib.types.enum [
              "lua"
              "viml"
              "teal"
              "fennel"
            ]) lib.types.str;
            description = "Language used in config. Configurations are aggregated per-language.";
            default = "viml";
          };

          plugin = lib.mkOption {
            type = lib.types.package;
            description = "vim plugin";
          };

        };
      };
    in
    {
      options = {
        enable = lib.mkEnableOption "Enable support for ${name}";
        treesitterGrammars = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.anything);
          default = null;
          description = "List of TreeSitter grammars for ${name}";
        };
        formatters = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  packages = lib.mkOption {
                    type = lib.types.listof lib.types.package;
                    default = [ ];
                    description = "List of packages for each formatters";
                  };
                  formatters = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                    description = "List of formatters for ${name}";
                  };
                  stop_after_first = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                    description = "Stop after the first successful formatter";
                  };
                  lsp_format = lib.mkOption {
                    type = lib.types.nullOr (
                      lib.types.enum [
                        "never"
                        "fallback"
                        "prefer"
                        "first"
                        "last"
                      ]
                    );
                    default = null;
                    description = "LSP format option for ${name}";
                  };
                };
              }
            )
          );
          default = null;
        };
        extraPackages = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.package);
          default = null;
          description = "Extra packages to install for ${name} (e.g., LSP)";
        };
        extraPlugins = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.listOf (
              lib.types.oneOf [
                lib.types.package
                pluginWithConfigType
              ]
            )
          );
          default = null;
          description = "Extra Neovim plugins for ${name}";
        };
        extraLuaConfig = lib.mkOption {
          type = lib.types.nullOr (lib.types.lines);
          default = null;
          description = "Extra Neovim configuration for ${name}";
        };
        lspConfig = lib.mkOption {
          type = lib.types.nullOr (lib.types.lines);
          default = null;
          description = "LSP configuration for ${name}";
        };
      };
    };

  allLanguages = lib.mapAttrs (
    name: lang:
    {
      enable = enabledAll;
      treesitterGrammars = [ ];
      formatters = { };
      extraPackages = [ ];
      extraPlugins = [ ];
      extraLuaConfig = "";
      lspConfig = "";
    }
    // lang
    // (lib.filterAttrs (n: v: v != null) (lib.attrByPath [ name ] { } cfg))
  ) defaultLanguages;

  enabledLanguages = lib.filterAttrs (name: lang: lang.enable) (allLanguages);
  enabledFormatters = if allFormatters then allLanguages else enabledLanguages;

  formattersToLua =
    lang: formatterConfig:
    let
      formatters = formatterConfig.formatters or [ ];
      quotedFormatters = map (f: ''"${f}"'') formatters;
      formattersList = lib.concatStringsSep ", " quotedFormatters;
      optionsStr = lib.concatStringsSep ", " (
        lib.remove null [
          (
            if formatterConfig.stop_after_first or null != null then
              "stop_after_first = ${if formatterConfig.stop_after_first then "true" else "false"}"
            else
              null
          )
          (
            if formatterConfig.lsp_format or null != null then
              ''lsp_format = "${formatterConfig.lsp_format}"''
            else
              null
          )
        ]
      );
      allOptions = lib.concatStringsSep ", " (
        lib.remove null [
          (if formattersList != "" then formattersList else null)
          (if optionsStr != "" then optionsStr else null)
        ]
      );
    in
    ''["${lang}"] = { ${allOptions} },'';

  formatterEntries = lib.concatStringsSep "\n" (
    lib.mapAttrsToList formattersToLua (
      lib.foldl (acc: lang: acc // lang.formatters) { } (lib.attrValues enabledFormatters)
    )
  );

in
{
  options.nvim-config.allLanguages = {
    enable = lib.mkEnableOption "Enable all default language support";
    grammars = lib.mkEnableOption "Download all grammars";
    formatters = lib.mkEnableOption "Include all formatters";
  };
  options.nvim-config.languages = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule languageOptions);
    default = { };
    description = "Language-specific configurations for Neovim";
  };

  config = {
    programs.neovim = {
      plugins =
        lib.lists.unique (lib.concatMap (lang: lang.extraPlugins) (lib.attrValues enabledLanguages))
        ++ (
          if allGrammars then
            (map pkgs.vimPlugins.nvim-treesitter.grammarToPlugin pkgs.vimPlugins.nvim-treesitter.allGrammars)
          else
            lib.lists.unique (lib.concatMap (lang: lang.treesitterGrammars) (lib.attrValues enabledLanguages))
        )
        ++ [
          {
            plugin = pkgs.vimPlugins.nvim-treesitter;
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
          {
            plugin = pkgs.vimPlugins.conform-nvim;
            runtime."after/plugin/conform.lua".text = ''
              local conform = require('conform')

              local slow_format_filetypes = {}
              conform.setup({
                formatters_by_ft = {
                ${formatterEntries}
                },
                format_on_save = function(bufnr)
                  if slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end
                  local function on_format(err)
                    if err and err:match("timeout$") then
                      slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                  end

                  return { timeout_ms = 200, lsp_fallback = true }, on_format
                end,

                format_after_save = function(bufnr)
                  if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                  end
                  return { lsp_fallback = true }
                end,
              })

              vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
                conform.format({
                  lsp_fallback = true,
                  timeout_ms = 1500,
                })
              end)
            '';
          }
          pkgs.vimPlugins.playground
        ];
      extraLuaConfig = ''
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: lang: lang.extraLuaConfig) enabledLanguages)}
      '';
    };
    home.packages = lib.lists.unique (
      lib.concatMap (
        lang: lib.concatMap (formatters: formatters.packages or [ ]) (lib.attrValues lang.formatters)
      ) (lib.attrValues enabledFormatters)
      ++ lib.concatMap (lang: lang.extraPackages) (lib.attrValues enabledLanguages)
    );
  };
}
