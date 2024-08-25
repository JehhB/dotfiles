{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eco";
  home.homeDirectory = "/home/eco";
  xdg.cacheHome = "/home/eco/.nix/cache";
  xdg.configHome = "/home/eco/.nix/config";
  xdg.dataHome = "/home/eco/.nix/data";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fzf
  ];

  programs.git = {
    enable = true;
    userName = "JehhB";
    userEmail = "jwy.bayod@gmail.com";
    aliases = {
      graph = "log --graph --pretty=format:'%C(magenta)%an%Creset %C(yellow)%h%Creset %C(auto)%d%Creset %s' --date=short --abbrev-commit --all";
    };
  };

  programs.neovim = {
  	enable = true;
    defaultEditor = true;
  };

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

    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
      ];
    };

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreAllDups = true;
      ignoreSpace = true;
    };


    initExtra = ''
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc'
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/eco/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    PS1 = "%B[%(!.%F{red}.%F{cyan})%n@%M%f %F{blue}%1~%f] %(!.#.$)%b ";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
