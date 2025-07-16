{
  config,
  pkgs,
  lib,
  ...
}:
let
  isInstalled = pkg: lib.any (p: p == pkg) config.home.packages;
in
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

    initContent = ''
      ${builtins.readFile ./init-extra.zsh}

      ${lib.optionalString (isInstalled pkgs.fzf) ''
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
      ''}

      ${lib.optionalString (isInstalled pkgs.fnm) ''
        FNM_PATH="${pkgs.fzf}/bin"
        if [ -d "$FNM_PATH" ]; then
          eval "`fnm env`"
        fi
      ''}

      command_not_found_handler() {
        /run/current-system/sw/bin/command-not-found "$@"
      }
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
