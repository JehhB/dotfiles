{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    vanilla-dmz
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme =  "BreezeDark";
      theme = "breeze-dark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "breeze-dark";
      cursor = {
        theme = "DMZ-White";
        size = 24;
      };
    };

    panels = [
      {
        location = "bottom";
        alignment = "center";
        floating = false;
        lengthMode = "fill";
        height = 44;
        widgets = [
          "org.kde.plasma.panelspacer"
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                showRecentApps = false;
                showRecentDocs = false;
              };
            };
          }
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "applications:kitty.desktop"
                  "applications:org.kde.dolphin.desktop"
                ];
              };
            };
          }
          "org.kde.plasma.panelspacer"
        ];
      }

      {
        location = "top";
        alignment = "center";
        floating = false;
        lengthMode = "fill";
        height = 27;
        widgets = [
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                autoFontAndSize = false;
                fontFamily = "Noto Sans";
                fontSize = 9;
                fontStyleName = "Regular";
                fontWeight = 400;
                showDate = false;
                use24hFormat = 2;
              };
            };
          }
        ];
      }
    ];
  };
}
