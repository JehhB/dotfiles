{ config, pkgs, ... }:

{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      luaConfig.pre = ''
        local conform_slow_format_filetypes = {}
      '';
      autoInstall = {
        enable = true;
        overrides = {
          prettier = null;
        };
      };
      settings = {
        formatters_by_ft = { };
        format_on_save = # lua
          ''
            function(bufnr)
              if conform_slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end
              local function on_format(err)
                if err and err:match("timeout$") then
                  conform_slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 200, lsp_fallback = true }, on_format
            end
          '';
        format_after_save = # lua
          ''
            function(bufnr)
              if not conform_slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end
              return { lsp_fallback = true }
            end
          '';
        default_format_opts.lsp_format = "fallback";
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>fm";
        action.__raw = ''
          function()
            require('conform').format({
              lsp_fallback = true,
              timeout_ms = 1500,
            })
          end
        '';
      }
    ];
  };
}
