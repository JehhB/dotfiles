{ pkgs }:

{
  angular-language-server = pkgs.callPackage ./angular-language-server { };
  sqls-nvim = pkgs.callPackage ./sqls-nvim { };
  twiggy-language-server = pkgs.callPackage ./twiggy-language-server { };
}
