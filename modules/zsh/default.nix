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

    initContent = # sh
      ''
        if [ -f /etc/zshrc ]; then
          source /etc/zshrc
        fi

        setopt extendedglob nomatch
        unsetopt autocd beep notify

        zstyle ':completion:*' menu select
        autoload edit-command-line;
        zle -N edit-command-line

        function zle-keymap-select () {
            case $KEYMAP in
                vicmd) echo -ne '\e[1 q';;
                viins|main) echo -ne '\e[5 q';;
            esac
        }
        zle -N zle-keymap-select
        zle-line-init() {
            zle -K viins
            echo -ne "\e[5 q"
        }
        zle -N zle-line-init
        echo -ne '\e[5 q'
        preexec() { echo -ne '\e[5 q' ;}

        setopt PROMPT_SUBST
        export PS1="%B[%(!.%F{red}.%F{cyan})%n@%M%f %F{blue}%1~%f] %(!.#.$)%b "

        ${lib.optionalString (isInstalled pkgs.fzf) # sh
          ''
            source ${pkgs.fzf}/share/fzf/key-bindings.zsh
            source ${pkgs.fzf}/share/fzf/completion.zsh
          ''
        }

        ${lib.optionalString (isInstalled pkgs.fnm) # sh
          ''
            FNM_PATH="${pkgs.fzf}/bin"
            if [ -d "$FNM_PATH" ]; then
              eval "`fnm env`"
            fi
          ''
        }

        command_not_found_handler() {
          /run/current-system/sw/bin/command-not-found "$@"
        }
      '';

    shellAliases = {
      t = "tmux";
      tp = "tmuxp load";
      v = "nvim";
      c = "clear";
      q = "exit";

      ls = "ls -hN --color=auto --group-directories-first";
      ll = "ls -l";
      l = "ll -A";
      grep = "grep --color=auto";
      diff = "diff --color=auto";

      bat = "batcat";
      pc = "podman-compose";
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
