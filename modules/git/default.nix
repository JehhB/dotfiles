{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "JehhB";
        email = "jwy.bayod@gmail.com";
      };
      alias = {
        graph = "log --graph --pretty=format:'%C(magenta)%an%Creset %C(yellow)%h%Creset %C(auto)%d%Creset %s' --date=short --abbrev-commit --all";
        unstage = "restore --staged";
      };
      init.defaultBranch = "main";
    };

    ignores = [
      ".tmuxp.yaml"
      ".tmuxp.json"
      "ai.md"
    ];
  };
}
