{ config, pkgs, ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
      settings = {
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_decremental = "V";
            node_incremental = "v";
          };
        };
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
      };
    };

    colorschemes = {
      gruvbox-material-nvim = {
        enable = true;
        settings = {
          italics = true;
          contrast = "hard";
          comments = {
            italics = true;
          };
          background = {
            transparent = false;
          };
          float = {
            force_background = false;
            background_color.__raw = "nil";
          };
          signs = {
            force_background = true;
          };
          customize.__raw = "nil";
        };
      };
    };

    plugins.lualine = {
      enable = true;
      settings.options = {
        theme = "gruvbox-material";
        section_separators = "";
        component_separators = "";
      };
    };

    plugins = {
      rainbow-delimiters.enable = true;
      colorizer.enable = true;
      indent-blankline.enable = true;
    };

    plugins.web-devicons.enable = true;
  };
}
