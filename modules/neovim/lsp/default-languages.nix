{ config, pkgs }:

let
  prettier_format = {
    stop_after_first = true;
    formatters = [
      "eslint_d"
      "prettierd"
      "prettier"
    ];
  };
in
{
  clang = {
    treesitterGrammars = p: [
      p.c
      p.cpp
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
    treesitterGrammars = p: [
      p.css
    ];
    extraPackages = with pkgs; [
      eslint_d
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
          "css",
          "eruby",
          "html",
          "htmldjango",
          "javascriptreact",
          "less",
          "php",
          "pug",
          "sass",
          "scss",
          "twig",
          "typescriptreact",
          "vue",
        },
        single_file_support = true
      }
    '';
  };
  glsl = {
    treesitterGrammar = p: [ p.glsl ];
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
    treesitterGrammars = p: [
      p.html
    ];
    extraPackages = with pkgs; [
      eslint_d
      prettierd
      vscode-langservers-extracted
    ];
    formatters.html = prettier_format;
    lspConfig = ''
      lspconfig.html.setup{}
    '';
  };
  lua = {
    treesitterGrammars = p: [ p.lua ];
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
    treesitterGrammars = p: [ p.nix ];
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
    formatters.nix = [ "nixfmt" ];
    extraLuaConfig = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "php",
        callback = function()
          vim.cmd("TSBufDisable highlight")
        end,
      })
    '';
    lspConfig = ''
      lspconfig.nil_ls.setup{
        cmd = { 'nil' },
        filetypes = { 'nix' },
      }
    '';
  };
  php = {
    treesitterGrammars = p: [
      p.php_only
      p.phpdoc
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
            angular = "html",
            vue = "html",
          },
        },
        filetypes = {
          "html",
          "angular",
          "css",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "markdown",
          "mdx",
          "php",
          "postcss",
          "sass",
          "scss",
          "svelte",
          "twig",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass", "[a-z-]+-class" }
          }
        }
      }
    '';
  };
  typescript = {
    treesitterGrammars = p: [
      p.javascript
      p.tsx
      p.typescript
      p.jsdoc
    ];
    extraPackages = with pkgs; [
      eslint_d
      prettierd
      typescript-language-server
    ];
    formatters = {
      javascript = prettier_format;
      javascriptreact = prettier_format;
      typescript = prettier_format;
      typescriptreact = prettier_format;
    };
    lspConfig =
      let
        vueSupport = config.nvim-config.languages.vue.enable;
      in
      ''
        lspconfig.ts_ls.setup{
          init_options = {
            plugins = {
              ${
                if vueSupport then
                  ''
                    {
                      name = "@vue/typescript-plugin",
                      location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
                      languages = {"javascript", "typescript", "vue"},
                    },
                  ''
                else
                  ""
              }
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            ${if vueSupport then ''"vue",'' else ""}
          },
        }
      '';
  };
  vue = {
    treesitterGrammars = p: [ p.vue ];
    extraPackages = with pkgs; [
      eslint_d
      prettierd
      vue-language-server
    ];
    formatters.vue = prettier_format;
    lspConfig = ''
      lspconfig.volar.setup{}
    '';
  };
}
