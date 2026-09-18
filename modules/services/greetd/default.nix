{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf getExe;

  cfg = config.cfg.services.greetd;

  greetings =
    (builtins.fromTOML (builtins.readFile ./greetings.toml)).greetings;

  randomGreeting = pkgs.writeShellScript "random-greeting" ''
    greetings=(
      ${lib.concatMapStringsSep "\n" lib.escapeShellArg greetings}
    )

    greeting="''${greetings[$RANDOM % ''${#greetings[@]}]}"

    config="$(${pkgs.coreutils}/bin/mktemp)"

    cat > "$config" <<EOF
[display]
greeting = "$greeting"
show_time = true
show_title = false
battery = true

[layout]
window_padding = 1

[layout.widgets]
time_position = "top"
status_position = "bottom"

[layout.widgets.status_bar]
show_reset = false
show_command = false
show_session = false
show_session_status = false
show_background = false

[session]
command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop"

[secret]
mode = "characters"
characters = "*"

[remember]
default_user = "${config.cfg.core.username}"
username = true

[power]
use_setsid = false
shutdown = "systemctl poweroff"
reboot = "systemctl reboot"
suspend = "systemctl suspend"
hibernate = ""
EOF

    trap '${pkgs.coreutils}/bin/rm -f "$config"' EXIT

    exec ${getExe pkgs.tuigreet} --config "$config"
  '';

in
{
  options.cfg.services.greetd.enable = mkEnableOption "greetd";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;

      settings = {
        default_session = {
          command = randomGreeting;
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";

      TTYPath = "/dev/tty1";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}