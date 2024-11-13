{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "JehhB";
    userEmail = "jwy.bayod@gmail.com";
    aliases = {
      graph = "log --graph --pretty=format:'%C(magenta)%an%Creset %C(yellow)%h%Creset %C(auto)%d%Creset %s' --date=short --abbrev-commit --all";
      unstage = "restore --staged";
    };
  };
}
