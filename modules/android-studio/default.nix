{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    android-studio
  ];
  programs.java.enable = true;
}
