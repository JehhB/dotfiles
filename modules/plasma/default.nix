{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vanilla-dmz
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
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
        height = 45;
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
                  "applications:firefox-esr.desktop"
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
        height = 28;
        widgets = [
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
              ];
            };
          }
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

    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay = {
          enable = true;
          idleTimeout = 300;
        };
        powerButtonAction = "showLogoutScreen";
        turnOffDisplay = {
          idleTimeout = 600;
          idleTimeoutWhenLocked = 60;
        };
        whenLaptopLidClosed = "turnOffScreen";
      };
      battery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 600;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 150;
        };
        powerButtonAction = "showLogoutScreen";
        turnOffDisplay = {
          idleTimeout = 300;
          idleTimeoutWhenLocked = 60;
        };
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standbyThenHibernate";
      };
      lowBattery = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 150;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60;
        };
        powerButtonAction = "showLogoutScreen";
        turnOffDisplay = {
          idleTimeout = 300;
          idleTimeoutWhenLocked = 120;
        };
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standbyThenHibernate";
      };
    };

    shortcuts = {
      kwin = {
        "Overview" = [
          "Meta"
          "Meta+W"
        ];
        "Window Close" = [
          "Alt+Q"
          "Alt+F4"
        ];
        "Window Maximize" = "Alt+Space";
      };
      "services/org.kde.dolphin.desktop"._launch = [ "Alt+F" ];
      "services/firefox-esr.desktop"._launch = [ "Alt+B" ];
      "services/kitty.desktop"._launch = [ "Alt+X" ];
      "services/org.kde.krunner.desktop"._launch = [
        "Alt+P"
        "Search"
      ];
    };

    spectacle.shortcuts = {
      captureActiveWindow = "Ctrl+Print";
      captureEntireDesktop = "Print";
      captureRectangularRegion = "Shift+Print";
      captureWindowUnderCursor = "Meta+Ctrl+Print";
      recordScreen = "Meta+Alt+R";
      recordRegion = "Meta+Alt+Shift+R";
      launch = "Meta+Shift+S";
    };

    input.mice = [
      {
        name = "TPPS/2 IBM TrackPoint";
        vendorId = "0002";
        productId = "000a";
        enable = true;
        naturalScroll = true;
      }
    ];
    input.touchpads = [
      {
        name = "SynPS/2 Synaptics TouchPad";
        vendorId = "0002";
        productId = "0007";
        enable = true;
        naturalScroll = true;
      }
      {
        name = "Synaptics TM2668-001";
        vendorId = "06cb";
        productId = "0000";
        enable = true;
        naturalScroll = true;
      }
    ];
    input.keyboard.options = [
      "caps:swapescape"
      "lv3:ralt_alt"
    ];

    configFile = {
      kwinrc.Desktops.Number = {
        value = 3;
      };
    };

    fonts = {
      general = {
        family = "Noto Sans";
        pointSize = 12;
      };
      fixedWidth = {
        family = "Hack";
        pointSize = 12;
      };
      small = {
        family = "Noto Sans";
        pointSize = 10;
      };
      toolbar = {
        family = "Noto Sans";
        pointSize = 12;
      };
      menu = {
        family = "Noto Sans";
        pointSize = 12;
      };
      windowTitle = {
        family = "Noto Sans";
        pointSize = 12;
      };
    };
  };
}
