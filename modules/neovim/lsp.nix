{ config, pkgs, ... }:

{
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      luaConfig.pre = ''
        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        lsp_capabilities = require('cmp_nvim_lsp').default_capabilities(lsp_capabilities)
      '';
      keymaps = [
        {
          mode = "n";
          key = "K";
          lspBufAction = "hover";
        }
        {
          mode = "n";
          key = "gD";
          lspBufAction = "declaration";
        }
        {
          mode = "n";
          key = "gs";
          lspBufAction = "signature_help";
        }
        {
          mode = "n";
          key = "<leader>r";
          lspBufAction = "rename";
        }
        {
          mode = "n";
          key = "<leader>a";
          lspBufAction = "code_action";
        }
      ];
      servers = {
        "*" = {
          config.capabilities.__raw = "lsp_capabilities";
        };
      };
    };
  };
}
