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
  angular = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      angular
    ];
    extraPackages = with pkgs; [
      userPackages.angular-language-server
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
        "--ngProbeLocations", "${pkgs.userPackages.angular-language-server}/lib/node_modules/@angular/language-server/"
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
  docker-compose = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      yaml
    ];
    extraPackages = with pkgs; [
      prettierd
      docker-compose-language-service
    ];
    formatters."yaml.docker-compose" = prettier_format;
    extraLuaConfig = ''
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml"},
        command = "setfiletype yaml.docker-compose"
      })
    '';
    lspConfig = ''
      lspconfig.docker_compose_language_service.setup{}
    '';
  };
  dockerfile = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      dockerfile
    ];
    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs
    ];
    formatters.dockerfile.lsp_format = "prefer";
    lspConfig = ''
      lspconfig.dockerls.setup{}
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
  json = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      json
    ];
    extraPackages = with pkgs; [
      prettierd
      vscode-langservers-extracted
    ];
    formatters.json = prettier_format;
    lspConfig = ''
      lspconfig.jsonls.setup {
        capabilities = lsp_capabilities,
      }
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
    formatters.php.lsp_format = "prefer";
    lspConfig = ''
      lspconfig.intelephense.setup{}
    '';
  };
  python = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      python
    ];
    extraPackages = with pkgs; [
      black
      isort
      pyright
    ];
    formatters.python = [
      "isort"
      "black"
    ];
    lspConfig = ''
      lspconfig.pyright.setup{}
    '';
  };
  sql = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      sql
    ];
    extraPlugins = with pkgs; [
      userPackages.sqls-nvim
    ];
    extraPackages = with pkgs; [
      nodePackages.sql-formatter
      sqls
    ];
    formatters.sql = [ "sql_formatter" ];
    lspConfig = ''
      require'lspconfig'.sqls.setup{
        on_attach = function(client, bufnr)
          require('sqls').on_attach(client, bufnr)
        end
      }
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
  yaml = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      yaml
    ];
    extraPackages = with pkgs; [
      prettierd
      yaml-language-server
    ];
    formatters.yaml = prettier_format;
    lspConfig = ''
      lspconfig.yamlls.setup{}
    '';
  };
}
