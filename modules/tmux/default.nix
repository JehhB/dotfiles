{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "M-a";
    baseIndex = 1;
    keyMode = "vi";

    tmuxp.enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
      {
        plugin = pkgs.userPackages.tmux-gruvbox-z3z1ma;
        extraConfig = ''
          set -g @gruvbox_flavour "material"

          set -g @gruvbox_window_default_text "#W"
          set -g @gruvbox_window_current_text "#W"

          set -g @gruvbox_status_modules_right "session date_time"
          set -g @gruvbox_date_time_text "%Y-%m-%d %H:%M:%S"

          set -g @gruvbox_status_left_separator "█"
          set -g @gruvbox_status_right_separator "█"
        '';
      }
    ];

    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
  };
}
