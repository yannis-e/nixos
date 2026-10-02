{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.cfg.programs.platformio.enable =
    mkEnableOption "PlatformIO";

  config = mkIf config.cfg.programs.platformio.enable {

    hj.packages = with pkgs; [
      platformio
      openocd
    ];

    services.udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];

    users.groups.plugdev = {};

    users.users.yannis.extraGroups = [
      "plugdev"
    ];
  };
}