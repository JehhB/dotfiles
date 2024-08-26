{ config, pkgs, ... } :

{
  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
      (mkTmuxPlugin {
        pluginName = "gruvbox-truecolor";
        rtpFilePath = "colorscheme-tpm.tmux";
        version = "unstable-2023-08-03";
        src = pkgs.fetchFromGitHub {
          owner = "LawAbidingCactus";
          repo = "tmux-gruvbox-truecolor";
          rev = "bcc1d78310c94de59be860f3d5ec277878e34e73";
          sha256 = "d04457297dd18ec2534c709edb1d19b6f4ae5d1c5a53bc7d0be229a8a94a9c21";
        };
      })
    ];

    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
  };
}
