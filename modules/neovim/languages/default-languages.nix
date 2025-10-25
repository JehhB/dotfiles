{
  config,
  lib,
  pkgs,
  ...
}:

let
  prettier_format = {
    __unkeyed-1 = "prettier";
    __unkeyed-2 = "prettierd";
    stop_after_first = true;
  };

  isEnabled = name: config.vim-languages.${name}.enable or config.vim-languages."*".enable or false;
  mkIfEn = name: value: lib.mkIf (isEnabled name) value;
  optIf = name: arr: lib.optionals (isEnabled name) arr;
  optAIf = name: attr: lib.optionalAttrs (isEnabled name) attr;
in
{
  config.programs.nixvim = lib.mkMerge [
    (mkIfEn "angular" {
      autoCmd = [
        {
          event = [
            "BufEnter"
            "BufRead"
          ];
          pattern = [
            "*.component.html"
            "*.page.html"
          ];
          callback.__raw = ''
            function()
              vim.bo.filetype = "htmlangular"
            end
          '';
        }
      ];
      plugins.conform-nvim.settings.formatters_by_ft.htmlangular = prettier_format;
      lsp.servers.angularls = {
        enable = true;
      };
    })
    (mkIfEn "astro" {
      lsp.servers.astro.enable = true;
    })
    (mkIfEn "clang" {
      lsp.servers.clangd.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.c = [ "clang-format" ];
      plugins.conform-nvim.settings.formatters_by_ft.cpp = [ "clang-format" ];
    })
    (mkIfEn "csharp" {
      lsp.servers.omnisharp.enable = true;
    })
    (mkIfEn "css" {
      lsp.servers.cssls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.css = prettier_format;
    })
    (mkIfEn "django" {
      plugins.conform-nvim.settings.formatters_by_ft.htmldjango = [ "djlint" ];
    })
    (mkIfEn "docker" {
      autoCmd = [
        {
          event = [
            "BufEnter"
            "BufRead"
          ];
          pattern = [
            "docker-compose.yaml"
            "docker-compose.yml"
            "compose.yaml"
            "compose.yml"
          ];
          callback.__raw = ''
            function()
              vim.bo.filetype = "yaml.docker-compose"
            end
          '';
        }
      ];
      lsp.servers.docker_language_server.enable = true;
    })
    (mkIfEn "emmet" {
      lsp.servers.emmet_language_server = {
        enable = true;
        config = {
          filetypes =
            optIf "angular" [ "htmlangular" ]
            ++ optIf "astro" [ "astro" ]
            ++ optIf "css" [
              "css"
              "less"
              "sass"
              "scss"
            ]
            ++ optIf "django" [ "htmldjango" ]
            ++ optIf "html" [ "html" ]
            ++ optIf "markdown" [ "markdown" ]
            ++ optIf "php" [ "php" ]
            ++ optIf "twig" [ "twig" ]
            ++ optIf "typescript" [
              "javascriptreact"
              "typescriptreact"
            ]
            ++ optIf "vue" [ "vue" ];
        };
      };
    })
    (mkIfEn "eslint" {
      lsp.servers.eslint = {
        enable = true;
        config = {
          filetypes =
            optIf "angular" [ "htmlangular" ]
            ++ optIf "astro" [ "astro" ]
            ++ optIf "svelte" [ "svelte" ]
            ++ optIf "typescript" [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ]
            ++ optIf "vue" [ "vue" ];
        };
      };
    })
    (mkIfEn "glsl" {
      autoCmd = [
        {
          event = [
            "BufEnter"
            "BufRead"
          ];
          pattern = [
            "*.glsl"
            "*.vert"
            "*.tesc"
            "*.tese"
            "*.frag"
            "*.geom"
            "*.comp"
          ];
          callback.__raw = ''
            function()
              vim.bo.filetype = "glsl"
            end
          '';
        }
      ];
      lsp.servers.glsl_analyzer.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.glsl = [ "clang-format" ];
    })
    (mkIfEn "html" {
      lsp.servers.html.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.html = prettier_format;
    })
    (mkIfEn "json" {
      lsp.servers.jsonls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.json = prettier_format;
    })
    (mkIfEn "lua" {
      lsp.servers.lua_ls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.lua = [ "stylua" ];
    })
    (mkIfEn "markdown" {
      lsp.servers.marksman.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.markdown = prettier_format;
    })
    (mkIfEn "nix" {
      lsp.servers.nil_ls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
    })
    (mkIfEn "php" {
      lsp.servers.phpactor.enable = true;
    })
    (mkIfEn "python" {
      lsp.servers.pyright.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.python = [
        "black"
        "isort"
      ];
    })
    (mkIfEn "sql" {
      lsp.servers.sqls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.sql = [ "sql_formatter" ];
    })
    (mkIfEn "tailwindcss" {
      lsp.servers.tailwindcss = {
        enable = true;
        config = {
          filetypes =
            optIf "astro" [ "astro" ]
            ++ optIf "angular" [ "htmlangular" ]
            ++ optIf "django" [ "htmldjango" ]
            ++ optIf "html" [ "html" ]
            ++ optIf "css" [
              "css"
              "less"
              "sass"
              "scss"
            ]
            ++ optIf "typescript" [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ]
            ++ optIf "php" [ "php" ]
            ++ optIf "svelte" [ "svelte" ]
            ++ optIf "twig" [ "twig" ]
            ++ optIf "vue" [ "vue" ];
          settings = {
            tailwindCSS = {
              includeLanguages =
                optAIf "astro" { astro = "html"; }
                // optAIf "angular" { angular = "html"; }
                // optAIf "django" { htmldjango = "html"; }
                // optAIf "vue" { vue = "html"; };
              showPixelEquivalents = true;
              emmetCompletions = true;
              classAttributes = [
                "class"
                "className"
                "[a-zA-Z]+ClassName"
                "classList"
                "[a-z-]+-class"
              ]
              ++ optIf "angular" [ "ngClass" ];
              classFunctions = [
                "tw"
                "clsx"
                "tw\\.[a-z]+"
              ];
            };
          };
        };
      };
    })
    (mkIfEn "twig" {
      lsp.servers.twiggy_language_server.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.twig = prettier_format;
    })
    (mkIfEn "typescript" {
      lsp.servers.vtsls = {
        enable = true;

        config = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = optIf "vue" [
                  {
                    name = "@vue/typescript-plugin";
                    location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                    languages = [ "vue" ];
                    configNamespace = "typescript";
                  }
                ];
              };
            };
          };
          filetypes = [
            "javascript"
            "typescript"
            "javascriptreact"
            "typescriptreact"
          ]
          ++ optIf "astro" [ "astro" ]
          ++ optIf "vue" [ "vue" ];
        };
      };
      plugins.conform-nvim.settings.formatters_by_ft = {
        javascript = prettier_format;
        javascriptreact = prettier_format;
        typescript = prettier_format;
        typescriptreact = prettier_format;
      };
    })
    (mkIfEn "vue" {
      lsp.servers.vue_ls = {
        enable = true;
        package = pkgs.vue-language-server;
      };
      plugins.conform-nvim.settings.formatters_by_ft.vue = prettier_format;
    })
    (mkIfEn "yaml" {
      lsp.servers.yamlls.enable = true;
      plugins.conform-nvim.settings.formatters_by_ft.yaml = prettier_format;
    })
  ];
}
