{ config, pkgs, ... } :

{
  programs.zsh = {
  	enable = true;

    defaultKeymap = "viins";

    enableCompletion = true;

    syntaxHighlighting = {
      enable = true;
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreAllDups = true;
      ignoreSpace = true;
    };

    initExtra = ''
    ${builtins.readFile ./init-extra.zsh}
    source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    source ${pkgs.fzf}/share/fzf/completion.zsh
    '';

    shellAliases = {
      t = "tmux";
      v = "nvim";
      c = "clear";
      q = "exit";

      ls = "ls -hN --color=auto --group-directories-first";
      ll = "ls -l";
      l = "ll -A";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
    };
  };

  programs.command-not-found.enable = true;
}
