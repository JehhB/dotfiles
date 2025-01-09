{ config, pkgs, ... }:

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

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.command-not-found.enable = true;
}
