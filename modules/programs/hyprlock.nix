{
  lib,
  pkgs,
  config,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.hyprlock;
  land = config.cfg.programs.hyprland;
in
{
  options.cfg.programs.hyprlock.enable = mkEnableOption "hyprlock";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.hyprlock
      ];
    };
  };
}