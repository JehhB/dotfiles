{ config, pkgs, ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };
      keymaps = {
        "<C-p>" = {
          mode = "n";
          action = "find_files";
        };
        "<leader>fg" = {
          mode = "n";
          action = "git_files";
        };
        "<leader>rg" = {
          mode = "n";
          action = "live_grep";
        };
        "<leader>dg" = {
          mode = "n";
          action = "diagnostics";
        };
        "gd" = {
          mode = "n";
          action = "lsp_definitions";
        };
        "gr" = {
          mode = "n";
          action = "lsp_references";
        };
        "gi" = {
          mode = "n";
          action = "lsp_implementations";
        };
        "go" = {
          mode = "n";
          action = "lsp_type_definitions";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = #lua
        ''
          function()
            local telescope = require("telescope.builtin")
            local handle = io.popen("git rev-parse --is-inside-work-tree 3> /dev/null")
            if handle == nil then
              telescope.find_files({})
              return
            end

            local result = handle:read("*a")

            handle:close()

            if string.match(result, "true") then
              telescope.git_files({})
            else
              telescope.find_files({})
            end
          end
        '';
      }
    ];

  };
}
