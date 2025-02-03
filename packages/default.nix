{ pkgs }:

{
  angular-language-server = pkgs.callPackage ./angular-language-server { };
  mdx-language-server = pkgs.callPackage ./mdx-language-server { };
  sqls-nvim = pkgs.callPackage ./sqls-nvim { };
  tmux-gruvbox-z3z1ma = pkgs.callPackage ./tmux-gruvbox-z3z1ma { };
  treesitter-mdx-nvim = pkgs.callPackage ./treesitter-mdx-nvim { };
  twiggy-language-server = pkgs.callPackage ./twiggy-language-server { };
}
