{ pkgs }:

{
  angular-language-server = pkgs.callPackage ./angular-language-server { };
  sqls-nvim = pkgs.callPackage ./sqls-nvim { };
}
