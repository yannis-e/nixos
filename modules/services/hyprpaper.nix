{
  lib,
  self,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.hyprpaper;
in
{
  options.cfg.services.hyprpaper.enable = mkEnableOption "hyprpaper";
  config = mkIf cfg.enable {
    hj = {
      xdg.data.files."walls".source = "${inputs.walls}/images"; # wallpapers

      packages = [ pkgs.hyprpaper ];
      xdg.config.files."hypr/hyprpaper.conf" = {
        generator = self.lib.generators.toHyprlang { };
        value = {
          splash = 0;
          "wallpaper[]".path = "~/.local/state/wallpaper";
        };
      };

      systemd.services.hyprpaper = {
        description = "Hyprpaper wallpaper manager";

        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = "${getExe pkgs.hyprpaper}";
          Restart = "on-failure";
        };

        restartTriggers = [
          config.hj.xdg.config.files."hypr/hyprpaper.conf".source
          pkgs.hyprpaper
        ];
      };
    };
  };
}
