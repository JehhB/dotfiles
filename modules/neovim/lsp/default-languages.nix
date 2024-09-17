{
  config,
  lib,
  pkgs,
}:

let
  prettier_format = {
    stop_after_first = true;
    formatters = [
      "prettierd"
      "prettier"
    ];
  };
  enabledAll = config.nvim-config.allLanguages.enable;
  hasLanguageSupport =
    lang:
    enabledAll
    || lib.attrByPath [
      lang
      "enable"
    ] false config.nvim-config.languages;
  ifSupported = lang: text: if hasLanguageSupport lang then text else "";
in
{
  angular =
    let
      ngserver = (
        pkgs.buildNpmPackage rec {
          pname = "angular-language-server";
          version = "18.2.0";

          src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
            hash = "sha256-UvYOxs59jOO9Yf0tvX96P4R/36qPeEne+NQAFkg9Eis=";
          };

          npmDepsHash = "sha256-avuVL7PI2uP5Y9hdHRCs10pBYUkTG0W6gqwZjM11Wjc=";

          postPatch = ''
            cp -s ${./angular.package-lock.json} package-lock.json
          '';

          dontNpmBuild = true;

          meta = {
            description = "Official Angular language server";
            homepage = "https://github.com/angular/vscode-ng-language-service#readme";
            changelog = "https://github.com/angular/vscode-ng-language-service/releases/tag/v${version}";
            license = lib.licenses.mit;
            mainProgram = "angular-language-server";
          };
        }
      );
    in
    {
      treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        angular
      ];
      extraPackages = with pkgs; [
        ngserver
        typescript
        prettierd
      ];
      formatters.angular = prettier_format;
      extraLuaConfig = ''
        vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
          pattern = { "*.component.html", "*.page.html" },
          callback = function()
            vim.bo.filetype = "angular"
          end
        });
      '';
      lspConfig = ''
        local angular_cmd = {
          "ngserver", "--stdio",
          "--tsProbeLocations", "${pkgs.typescript}/lib/",
          "--ngProbeLocations", "${ngserver}/lib/node_modules/@angular/language-server/"
        }
        lspconfig.angularls.setup{
          cmd = angular_cmd,
          on_new_config = function(new_config,new_root_dir)
            new_config.cmd = angular_cmd;
          end,
          filetypes = {
            "typescript",
            "angular",
            "typescriptreact",
            "typescript.tsx",
            "htmlangular"
          },
        }
      '';
    };
  clang = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      c
      cpp
    ];
    extraPackages = with pkgs; [ clang-tools ];
    formatters = {
      c = [ "clang-format" ];
      cpp = [ "clang-format" ];
    };
    lspConfig = ''
      lspconfig.clangd.setup{
        capabilities = lsp_capabilities;
      }
    '';
  };
  css = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      css
    ];
    extraPackages = with pkgs; [
      prettierd
      vscode-langservers-extracted
    ];
    formatters.css = prettier_format;
    lspConfig = ''
      lspconfig.cssls.setup{
        capabilities = lsp_capabilities;
      }
    '';
  };
  emmet = {
    extraPackages = with pkgs; [
      emmet-language-server
    ];
    lspConfig = ''
      lspconfig.emmet_language_server.setup{
        filetypes = {
          ${ifSupported "css" ''
            "css",
            "less",
            "sass",
            "scss",
          ''}
          ${ifSupported "html" ''"html",''}
          ${ifSupported "typescript" ''
            "javascriptreact",
            "typescriptreact",
          ''}
          ${ifSupported "vue" ''"vue",''}
          ${ifSupported "php" ''"php",''}
          ${ifSupported "twig" ''"twig",''}
        },
        single_file_support = true
      }
    '';
  };
  glsl = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      glsl
    ];
    extraPackages = with pkgs; [
      glsl_analyzer
      clang-tools
    ];
    formatters.glsl = [ "clang-format" ];
    lspConfig = ''
      lspconfig.glsl_analyzer.setup{
        capabilities = lsp_capabilities
      }
    '';
    extraLuaConfig = ''
      vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
        pattern = {"*.glsl", "*.vert", "*.tesc", "*.tese", "*.frag", "*.geom", "*.comp"},
        callback = function()
          vim.bo.filetype = "glsl"
        end,
      })
    '';
  };
  html = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      html
    ];
    extraPackages = with pkgs; [
      prettierd
      vscode-langservers-extracted
    ];
    formatters.html = prettier_format;
    lspConfig = ''
      lspconfig.html.setup{}
    '';
  };
  lua = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      lua
    ];
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
    formatters.lua = [ "stylua" ];
    lspConfig = ''
      lspconfig.lua_ls.setup{
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  version = 'LuaJIT'
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            })
          end
          return true
        end,
      }
    '';
  };
  nix = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ nix ];
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
    formatters.nix = [ "nixfmt" ];
    lspConfig = ''
      lspconfig.nil_ls.setup{
        cmd = { 'nil' },
        filetypes = { 'nix' },
      }
    '';
  };
  php = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      php
      phpdoc
    ];
    extraPackages = with pkgs; [
      nodePackages.intelephense
    ];
    formatters.php = {
      lsp_format = "prefer";
    };
    lspConfig = ''
      lspconfig.intelephense.setup{}
    '';
  };
  tailwindcss = {
    extraPackages = with pkgs; [
      tailwindcss-language-server
    ];
    lspConfig = ''
      lspconfig.tailwindcss.setup{
        init_options = {
          userLanguages = {
            ${ifSupported "angular" ''angular = "html",''}
            ${ifSupported "vue" ''vue = "html",''}
          },
        },
        filetypes = {
          ${ifSupported "angular" ''"angular",''}
          ${ifSupported "html" ''"html",''}
          ${ifSupported "css" ''
            "css",
            "less",
            "sass",
            "scss",
          ''}
          ${ifSupported "typescript" ''
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          ''}
          ${ifSupported "markdown" ''"markdown",''}
          ${ifSupported "php" ''"php",''}
          ${ifSupported "svelte" ''"svelte",''}
          ${ifSupported "twig" ''"twig",''}
          ${ifSupported "vue" ''"vue",''}
        },
        settings = {
          tailwindCSS = {
            classAttributes = {
              "class",
              "className",
              "classList",
              "[a-z-]+-class",
              ${ifSupported "angular" ''"ngClass",''}
            }
          }
        }
      }
    '';
  };
  typescript = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      javascript
      tsx
      typescript
      jsdoc
    ];
    extraPackages = with pkgs; [
      prettierd
      typescript-language-server
    ];
    formatters = {
      javascript = prettier_format;
      javascriptreact = prettier_format;
      typescript = prettier_format;
      typescriptreact = prettier_format;
    };
    lspConfig = ''
      lspconfig.ts_ls.setup{
        init_options = {
          plugins = {
            ${ifSupported "vue" ''
              {
                name = "@vue/typescript-plugin",
                location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
                languages = {"javascript", "typescript", "vue"},
              },
            ''}
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          ${ifSupported "vue" ''"vue",''}
        },
      }
    '';
  };
  vue = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ vue ];
    extraPackages = with pkgs; [
      prettierd
      vue-language-server
    ];
    formatters.vue = prettier_format;
    lspConfig = ''
      lspconfig.volar.setup{}
    '';
  };
}
