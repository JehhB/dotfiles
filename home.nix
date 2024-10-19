{ config, pkgs, ... }:

rec {
  imports = [
    modules/firefox
    modules/git
    modules/kitty
    modules/neovim
    modules/plasma
    modules/tmux
    modules/zsh
  ];

  home.username = "eco";
  home.homeDirectory = "/home/eco";
  xdg.cacheHome = "/home/eco/.cache";
  xdg.configHome = "/home/eco/.config";
  xdg.dataHome = "/home/eco/.local/share";

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
    vlc
    nodejs
    nodePackages.ts-node
    pnpm
    ripgrep
    ripgrep-all
    libreoffice-qt6-fresh
    wl-clipboard
    zoom-us
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    {
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
    PNPM_HOME = "${xdg.dataHome}/pnpm";
  };

  home.sessionPath = [
    home.sessionVariables.PNPM_HOME
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
