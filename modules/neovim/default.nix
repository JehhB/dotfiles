{ ... }:

{
  imports = [
    ./copilot.nix
    ./conform.nix
    ./git.nix
    ./grapple.nix
    ./keymap.nix
    ./lsp.nix
    ./nvim-cmp.nix
    ./telescope.nix
    ./theme.nix
    ./languages
  ];

  vim-languages = {
    astro.enable = false;
    clang.enable = true;
    csharp.enable = true;
    css.enable = true;
    # docker.enable = true; # currently broken builds
    emmet.enable = true;
    eslint.enable = true;
    html.enable = true;
    htmldjango.enable = true;
    json.enable = true;
    markdown.enable = true;
    nix.enable = true;
    python.enable = true;
    sql.enable = true;
    tailwindcss.enable = true;
    typescript.enable = true;
    vue.enable = false;
    yaml.enable = true;
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    diagnostic.settings = {
      virtual_text = {
        current_line = false;
      };
      severity_sort = true;
    };

    opts = {
      spelllang = "en_us";
      spell = true;

      secure = true;
      exrc = true;

      mouse = "a";
      wildmenu = true;
      wildmode = [
        "longest"
        "list"
        "full"
      ];
      wildignore = [
        "**/node_modules/*"
        "**/.git/*"
      ];

      signcolumn = "number";

      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;

      number = true;
      relativenumber = true;

      splitbelow = true;
      splitright = true;

      hlsearch = false;
      incsearch = true;

      laststatus = 2;
      showmode = false;
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    dependencies = {
      bat.enable = true;
      ripgrep.enable = true;
      fzf.enable = true;
    };

    plugins.lz-n.enable = true;
  };
}
