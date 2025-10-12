{ config, pkgs, ... }:

{
  imports = [
    ./options.nix
    ./default-languages.nix
  ];
}
