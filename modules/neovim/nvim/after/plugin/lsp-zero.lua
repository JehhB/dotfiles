local lsp_zero = require('lsp-zero')

lsp_zero.configure('nil_ls', {
  cmd = { 'nil' },
  filetypes = { 'nix' },
})

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    "angularls",
    "clangd",
    "cssls",
    "emmet_language_server",
    "glsl_analyzer",
    "html",
    "intelephense",
    "lua_ls",
    "tailwindcss",
    "tsserver",
    "twiggy_language_server",
    "volar",
  },
  handlers = {
    lsp_zero.default_setup,
    tsserver = function()
      local vue_language_server_path = require('mason-registry').get_package('vue-language-server'):get_install_path() ..
          '/node_modules/@vue/language-server'

      require('lspconfig').tsserver.setup {
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_language_server_path,
              languages = { 'vue' },
            },
          },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      }
    end,
    emmet_language_server = function()
      require('lspconfig').emmet_language_server.setup({
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
      })
    end,
    tailwindcss = function()
      require('lspconfig').tailwindcss.setup({
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
      })
    end,
    lua_ls = function()
      require 'lspconfig'.lua_ls.setup {
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
    end,
  },
})

require('mason-tool-installer').setup {
  ensure_installed = {
    "angularls",
    "clangd",
    "cssls",
    "emmet_language_server",
    "glsl_analyzer",
    "html",
    "intelephense",
    "lua_ls",
    "php-cs-fixer",
    "tailwindcss",
    "tsserver",
    "twiggy_language_server",
    "volar",
  },

  debounce_hours = 5,
  integrations = {
    ['mason-lspconfig'] = true,
  },
}
