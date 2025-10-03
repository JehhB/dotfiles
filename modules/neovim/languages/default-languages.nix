{
  config,
  lib,
  pkgs,
}:

let
  prettier_format = {
    stop_after_first = true;
    packages = [ pkgs.prettierd ];
    formatters = [
      "prettierd"
      "prettier"
    ];
  };
  clang_format = {
    packages = [ pkgs.clang-tools ];
    formatters = [ "clang-format" ];
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

  nodeAdapter = {
    "pwa-node" = {
      packages = [ pkgs.vscode-js-debug ];
      config = ''
        {
          type = "server",
          host = "localhost",
          port = "''${port}",
          executable = {
            command = "${pkgs.vscode-js-debug}/bin/js-debug",
            args = {"''${port}"}
          },
        }
      '';
    };
  };

  firefoxAdapter =
    let
      adapter = pkgs.vscode-extensions.firefox-devtools.vscode-firefox-debug;
    in
    {
      "firefox" = {
        packages = [ adapter ];
        config = ''
          {
            type = "executable",
            command = "node",
            args = "${adapter}/share/vscode/extensions/firefox-devtools.vscode-firefox-debug/dist/adapter.bundle.js",
          }
        '';
      };
    };

  gdbAdapter = {
    "gdb" = {
      packages = [ pkgs.gdb ];
      config = ''
        {
          type = "executable",
          command = "${pkgs.gdb}/bin/gdb",
          args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
        }
      '';
    };
  };

  gdbConfig = {
    config = ''
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "''${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false, 
      }
    '';
  };
in
{
  angular = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      angular
    ];
    extraPackages = with pkgs; [
      userPackages.angular-language-server
      typescript
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
      vim.lsp.config('angularls', {
        on_new_config = function(new_config,new_root_dir)
          new_config.cmd = angular_cmd;
        end,
        cmd = angular_cmd,
        filetypes = {
          "typescript",
          "angular",
          "typescriptreact",
          "typescript.tsx",
          "htmlangular"
        },
      })
    '';
    lspServers = [ "angularls" ];
  };
  astro = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      astro
    ];
    extraPackages = with pkgs; [
      typescript
      astro-language-server
    ];
    formatters.astro.lsp_format = "prefer";
    lspConfig = ''
      vim.lsp.config('astro', {
        init_options = {
          typescript = {
            tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib",
          },
        },
      })
    '';
    lspServers = [ "astro" ];
  };
  clang = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      c
      cpp
    ];
    extraPackages = with pkgs; [ clang-tools ];
    formatters.c = clang_format;
    formatters.cpp = clang_format;
    lspServers = [ "clangd" ];
    adapterConfig = gdbAdapter;
    dapConfig.c = gdbConfig;
    dapConfig.cpp = gdbConfig;
  };
  csharp = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      c_sharp
    ];
    extraPackages = with pkgs; [
      omnisharp-roslyn
      dotnet-sdk
      mono
    ];
    formatters.cs.lsp_format = "prefer";
    lspConfig = ''
      vim.lsp.config('omnisharp', {
        cmd = { "OmniSharp" },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = nil,
          },
          MsBuild = {
            LoadProjectsOnDemand = nil,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = nil,
            EnableImportCompletion = nil,
            AnalyzeOpenDocumentsOnly = nil,
          },
          Sdk = {
            IncludePrereleases = true,
          },
        },
      })
    '';
    lspServers = [ "omnisharp" ];
  };
  css = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      css
    ];
    extraPackages = with pkgs; [
      vscode-langservers-extracted
    ];
    formatters.css = prettier_format;
    lspServers = [ "cssls" ];
  };
  docker-compose = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      yaml
    ];
    extraPackages = with pkgs; [
      docker-compose-language-service
    ];
    formatters."yaml.docker-compose" = prettier_format;
    extraLuaConfig = ''
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml"},
        command = "setfiletype yaml.docker-compose"
      })
    '';
    lspServers = [ "docker_compose_language_service" ];
  };
  dockerfile = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      dockerfile
    ];
    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs
    ];
    formatters.dockerfile.lsp_format = "prefer";
    lspServers = [ "dockerls" ];
  };
  emmet = {
    extraPackages = with pkgs; [
      emmet-language-server
    ];
    lspConfig = ''
      vim.lsp.config('emmet_language_server', {
        filetypes = {
          ${ifSupported "astro" ''"astro",''}
          ${ifSupported "css" ''
            "css",
            "less",
            "sass",
            "scss",
          ''}
          ${ifSupported "html" ''"html",''}
          ${ifSupported "mdx" ''"mdx",''}
          ${ifSupported "php" ''"php",''}
          ${ifSupported "twig" ''"twig",''}
          ${ifSupported "htmldjango" ''"htmldjango",''}
          ${ifSupported "typescript" ''
            "javascriptreact",
            "typescriptreact",
          ''}
          ${ifSupported "vue" ''"vue",''}
        },
      })
    '';
    lspServers = [ "emmet_language_server" ];
  };
  eslint = {
    extraPackages = with pkgs; [
      vscode-langservers-extracted
    ];
    lspConfig = ''
      vim.lsp.config('eslint', {
        filetypes = {
          ${ifSupported "astro" ''"astro",''}
          ${ifSupported "typescript" ''
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          ''}
          ${ifSupported "vue" ''"vue",''}
        },
      })
    '';
    lspServers = [ "eslint" ];
  };
  glsl = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      glsl
    ];
    extraPackages = with pkgs; [
      glsl_analyzer
    ];
    formatters.glsl = clang_format;
    lspServers = [ "glsl_analyzer" ];
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
      vscode-langservers-extracted
    ];
    formatters.html = prettier_format;
    lspServers = [ "html" ];
  };
  htmldjango = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      htmldjango
    ];
    formatters.htmldjango = {
      packages = [
        pkgs.djlint
      ];
      formatters = [ "djlint" ];
    };
  };
  json = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      json
    ];
    extraPackages = with pkgs; [
      vscode-langservers-extracted
    ];
    formatters.json = prettier_format;
    lspServers = [ "jsonls" ];
  };
  lua = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      lua
    ];
    extraPackages = with pkgs; [
      lua-language-server
    ];
    formatters.lua = {
      packages = [ pkgs.stylua ];
      formatters = [ "stylua" ];
    };
    lspConfig = ''
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })
    '';
    lspServers = [ "lua_ls" ];
  };
  markdown = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ markdown ];
    extraPackages = with pkgs; [
      marksman
    ];
    formatters.markdown = prettier_format;
    lspServers = [ "marksman" ];
  };
  mdx = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ markdown ];
    extraPackages = with pkgs; [
      userPackages.mdx-language-server
      typescript
    ];
    formatters.mdx = prettier_format;
    lspConfig = ''
      vim.lsp.config('mdx_analyzer', {
        init_options = {
          typescript = {
            tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib",
          },
        },
      })
    '';
    lspServers = [ "mdx_analyzer" ];
    extraPlugins = with pkgs; [
      {
        plugin = userPackages.treesitter-mdx-nvim;
        runtime."after/plugin/treesitter-mdx-nvim.lua".text = ''require('mdx').setup()'';
      }
    ];
  };
  nix = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ nix ];
    extraPackages = with pkgs; [
      nil
    ];
    formatters.nix = {
      packages = [ pkgs.nixfmt-rfc-style ];
      formatters = [ "nixfmt" ];
    };
    lspServers = [ "nil_ls" ];
  };
  php = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      php
      phpdoc
    ];
    extraPackages = with pkgs; [
      phpactor
    ];
    formatters.php.lsp_format = "prefer";
    lspServers = [ "phpactor" ];
    adapterConfig.php =
      let
        adapter = pkgs.vscode-extensions.xdebug.php-debug;
      in
      {
        packages = [
          adapter
        ];
        config = ''
          {
            type = "executable",
            command = "node",
            args = { "${adapter}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js"},
          }
        '';
      };
    dapConfig.php =
      let
        php = (
          pkgs.php.buildEnv {
            extensions = (
              { enabled, all }:
              enabled
              ++ (with all; [
                xdebug
              ])
            );
            extraConfig = ''
              xdebug.mode=debug
              xdebug.start_with_request = yes
              xdebug.remote_port = 9003
            '';
          }
        );
      in
      {
        packages = [ php ];
        config = ''
          {
            type = "php",
            request = "launch",
            name = "Listen for Xdebug",
            port = 9003,
          }
        '';
      };
  };
  python = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      python
    ];
    extraPackages = with pkgs; [
      pyright
    ];
    formatters.python = {
      packages = [
        pkgs.black
        pkgs.isort
      ];
      formatters = [
        "isort"
        "black"
      ];
    };
    lspServers = [ "pyright" ];
    adapterConfig.python.config = ''
      function(cb, config)
        if config.request == 'attach' then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = config.pythonPath,
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
        end
      end
    '';
    dapConfig.python.config = ''
      {
        type = 'python';
        request = 'launch';
        name = "Launch file";

        program = "''${file}";
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end;
      },
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
      sqls
    ];
    formatters.sql = {
      packages = [ pkgs.nodePackages.sql-formatter ];
      formatters = [ "sql_formatter" ];
    };
    lspConfig = ''
      vim.lsp.config('sqls', {
        on_attach = function(client, bufnr)
          require('sqls').on_attach(client, bufnr)
        end
      })
    '';
    lspServers = [ "sqls" ];
  };
  tailwindcss = {
    extraPackages = with pkgs; [
      tailwindcss-language-server
    ];
    lspConfig = ''
      vim.lsp.config('tailwindcss', {
        filetypes = {
          ${ifSupported "astro" ''"astro",''}
          ${ifSupported "angular" ''"angular",''}
          ${ifSupported "html" ''"html",''}
          ${ifSupported "htmldjango" ''"htmldjango",''}
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
          ${ifSupported "mdx" ''"mdx",''}
          ${ifSupported "php" ''"php",''}
          ${ifSupported "svelte" ''"svelte",''}
          ${ifSupported "twig" ''"twig",''}
          ${ifSupported "vue" ''"vue",''}
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              ${ifSupported "astro" ''astro = "html",''}
              ${ifSupported "angular" ''angular = "html",''}
              ${ifSupported "vue" ''vue = "html",''}
              ${ifSupported "htmldjango" ''htmldjango = "html",''}
            },
            showPixelEquivalents = true,
            emmetCompletions = true,
            classAttributes = {
              "class",
              "className",
              "[a-zA-Z]+ClassName",
              "classList",
              "[a-z-]+-class",
              ${ifSupported "angular" ''"ngClass",''}
            },
            classFunctions = {
              "tw",
              "clsx",
              "tw\\.[a-z]+",
            },
          }
        }
      })
    '';
    lspServers = [ "tailwindcss" ];
  };
  twig = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      twig
    ];
    extraPackages = with pkgs; [
      userPackages.twiggy-language-server
    ];
    formatters.twig = prettier_format;
    lspServers = [ "twiggy_language_server" ];
  };
  typescript = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      javascript
      tsx
      typescript
      jsdoc
    ];
    extraPackages = with pkgs; [
      vtsls
    ];
    formatters = {
      javascript = prettier_format;
      javascriptreact = prettier_format;
      typescript = prettier_format;
      typescriptreact = prettier_format;
    };
    lspConfig = ''
      vim.lsp.config('vtsls', {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                ${ifSupported "vue" ''
                  {
                    name = "@vue/typescript-plugin",
                    location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server",
                    languages = { "vue" },
                    configNamespace = "typescript",
                  },
                ''}
              },
            },
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          ${ifSupported "astro" ''"astro",''}
          ${ifSupported "mdx" ''"mdx",''}
          ${ifSupported "vue" ''"vue",''}
        },
      })
    '';
    lspServers = [ "vtsls" ];
    adapterConfig = firefoxAdapter // nodeAdapter;
  };
  vue = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [ vue ];
    extraPackages = with pkgs; [
      vue-language-server
    ];
    formatters.vue = prettier_format;
    lspServers = [ "vue_ls" ];
  };
  yaml = {
    treesitterGrammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      yaml
    ];
    extraPackages = with pkgs; [
      yaml-language-server
    ];
    formatters.yaml = prettier_format;
    lspServers = [ "yamlls" ];
  };
}
