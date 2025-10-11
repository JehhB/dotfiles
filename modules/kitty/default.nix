{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.emptyDirectory;
    shellIntegration.enableZshIntegration = true;
    font = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    keybindings = {
      "kitty_mod+6" = "no_op";
    };
    extraConfig = ''
      disable_ligatures cursor
      enable_audio_bell no
      window_padding_width 8
      confirm_os_window_close 0
      modify_font underline_position +2
      modify_font underline_thickness 50%

      background #1d2021
      foreground #d4be98

      color0     #282828
      color8     #928374
      color1     #ea6962
      color9     #f38ba8
      color2     #a9b665
      color10    #b4b680
      color3     #d8a657
      color11    #e3a84f
      color4     #7daea3
      color12    #89b482
      color5     #d3869b
      color13    #d4879c
      color6     #89b482
      color14    #8ec07c
      color7     #d4be98
      color15    #e9d9a7
    '';
  };
}
