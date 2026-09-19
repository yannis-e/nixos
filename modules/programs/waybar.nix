{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
        };

        clock = {
          format = "{:%H:%M}";
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
        };

        network = {
          format-wifi = "{essid}";
          format-ethernet = "{ipaddr}";
          format-disconnected = "offline";
        };

        battery = {
          format = "{capacity}%";
        };
      };
    };

    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
      }

      window#waybar {
        background: #202020;
        color: #B9C1D6;
      }
    '';
  };
}