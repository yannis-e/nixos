{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
in
{
  options.cfg.services.greetd.enable = mkEnableOption "greetd";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${getExe pkgs.tuigreet} --config /etc/tuigreet/config.toml";
          user = "greeter";
        };
      };
    };

    # Prevent boot log overlap on TTY1
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

    environment.etc."tuigreet/config.toml".source =
      (pkgs.formats.toml { }).generate "tuigreet-config.toml"
        {
          display = {
            greeting = "Welcome back, ${config.cfg.core.username}!";
            show_time = true;
            show_title = false;
            battery = true;
          };
          layout = {
            window_padding = 1;
            widgets = {
              time_position = "top";
              status_position = "bottom";
              status_bar = {
                show_reset = false;
                show_command = false;
                show_session = false;
                show_session_status = false;
                show_background = false;
              };
            };
          };
          session.command = "${pkgs.hyprland}/bin/start-hyprland";
          secret = {
            mode = "characters";
            characters = "*";
          };
          remember = {
            default_user = config.cfg.core.username;
            username = true;
          };
          power = {
            use_setsid = false;
            shutdown = "systemctl poweroff";
            reboot = "systemctl reboot";
            suspend = "systemctl suspend";
            hibernate = "";
          };
        };
  };
}