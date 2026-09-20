{ config, lib, pkgs, self, ... }:

let
  inherit (lib) mkEnableOption mkIf getExe;

  cfg = config.cfg.programs.waybar;

  selfPkgs =
    self.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
in
{
  options.cfg.programs.waybar = {
    enable = mkEnableOption "Waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
    };

    hjem.users.yannis = {
      files = {
        ".config/waybar/config".text = builtins.toJSON {
          layer = "top";
          position = "top";
          height = 28;

          "modules-left" = [
            "hyprland/workspaces"
            "custom/mediaplayer"
          ];

          "modules-center" = [
            "clock"
          ];

          "modules-right" = [
            "wireplumber"
            "custom/bluetooth"
            "custom/battery"
            "tray"
          ];

          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            format = "{name}";
          };

          "hyprland/workspaces" = {
            format = "{name}";
          };

          "custom/mediaplayer" = {
            exec = getExe selfPkgs.mediaplayer;
            interval = 2;
            "return-type" = "text";
            "on-click" = "playerctl play-pause";
            "on-click-middle" = "playerctl previous";
            "on-click-right" = "playerctl next";
          };

          wireplumber = {
            format = "<span foreground='#ffb86c'>{icon} {volume}%</span>";
            "format-muted" =
              "<span foreground='#ff5555'>󰝟 Muted</span>";

            "format-icons" = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];

            "on-click" = "pwvucontrol";
            "on-click-right" =
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "scroll-step" = 5;
          };

          "custom/bluetooth" = {
            exec = getExe selfPkgs.bluetooth;
            interval = 5;
            "return-type" = "text";
            format = "{}";
            "on-click" = "foot -e bluetui";
          };

          "custom/battery" = {
            exec = getExe selfPkgs.battery;
            interval = 10;
            "return-type" = "text";
          };

          clock = {
            format =
              "<span foreground='#f1fa8c'> {:%Y-%m-%d %H:%M}</span>";
            interval = 10;
            tooltip = false;
          };

          tray = {
            spacing = 10;
          };
        };

        ".config/waybar/style.css".text = ''
          * {
              font-family: monospace;
              font-size: 13px;
              min-height: 0;
          }

          window#waybar {
              background: #202020;
              color: #B9C1D6;
          }

          /* Compact i3blocks-style spacing */

          #workspaces,
          #custom-mediaplayer,
          #clock,
          #wireplumber,
          #custom-bluetooth,
          #custom-battery,
          #tray {
              padding: 0 8px;
          }

          /* Workspaces */

          #workspaces button {
              padding: 0 6px;
              margin: 0;
              color: #B9C1D6;
              background: transparent;
              border: none;
              border-radius: 0;
              box-shadow: none;
          }

          #workspaces button:hover {
              background: transparent;
              box-shadow: none;
          }

          #workspaces button.active {
              background: #303030;
              box-shadow: none;
          }

          #workspaces button.urgent {
              background: transparent;
              box-shadow: none;
          }

          /* Tray */

          #tray {
              padding-right: 10px;
          }

          #tray > .passive {
              opacity: 0.7;
          }

          #tray > .needs-attention {
              opacity: 1;
          }

          /* Remove GTK/Waybar visual effects */

          button {
              border: none;
              box-shadow: none;
              text-shadow: none;
          }

          /* Tooltips */

          tooltip {
              background: #202020;
              border: 1px solid #404040;
              border-radius: 0;
          }

          tooltip label {
              color: #B9C1D6;
          }
        '';
      };
    };

    systemd.user.services.waybar = {
      description = "Waybar status bar";

      after = [
        "graphical-session.target"
      ];

      wantedBy = [
        "graphical-session.target"
      ];

      serviceConfig = {
        ExecStart = "${getExe pkgs.waybar}";
        Restart = "on-failure";
        RestartSec = 2;
      };

      restartTriggers = [
        pkgs.waybar
      ];
    };
  };
}