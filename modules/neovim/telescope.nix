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
        key = "<C-p>";
        action.__raw = "function() require('telescope.builtin').find_files({hidden = true}) end";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = ''
          function()
            local telescope = require("telescope.builtin")
            local handle = io.popen("git rev-parse --is-inside-work-tree 3> /dev/null")
            local opt = {hidden = true};

            if handle == nil then
              telescope.find_files(opt)
              return
            end

            local result = handle:read("*a")

            handle:close()

            if string.match(result, "true") then
              telescope.git_files(opt)
            else
              telescope.find_files(opt)
            end
          end
        '';
      }
    ];

  };
}
