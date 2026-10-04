{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.services.batteryNotifications;
in
{
  options.cfg.services.batteryNotifications = {
    enable = mkEnableOption "battery notifications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libnotify
    ];

    systemd.user.services.battery-notify = {
      description = "Battery level notification";

      serviceConfig = {
        Type = "oneshot";

        ExecStart = pkgs.writeShellScript "battery-notify" ''
          BAT="/sys/class/power_supply/BAT0"
          STATE="$HOME/.cache/battery-notify"

          [ -d "$BAT" ] || exit 0

          mkdir -p "$(dirname "$STATE")"

          capacity=$(cat "$BAT/capacity")
          status=$(cat "$BAT/status")

          # Reset notification state while charging
          if [ "$status" != "Discharging" ]; then
            rm -f "$STATE"
            exit 0
          fi

          level=$((capacity / 10 * 10))

          # Only notify at 10% intervals
          [ "$level" -ge 10 ] || exit 0
          [ $((capacity % 10)) -eq 0 ] || exit 0

          # Don't notify the same level repeatedly
          if [ -f "$STATE" ] && [ "$(cat "$STATE")" = "$level" ]; then
            exit 0
          fi

          echo "$level" > "$STATE"

          notify-send \
            -u normal \
            -i battery \
            "Battery: $capacity%"
        '';
      };
    };

    systemd.user.timers.battery-notify = {
      description = "Check battery level";

      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
      };

      wantedBy = [ "timers.target" ];
    };
  };
}