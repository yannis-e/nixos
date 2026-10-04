{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.networkmanager;
in
{
  options.cfg.core.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    programs.nm-applet.enable = true;

    networking.networkmanager = {
      enable = true;

      wifi.powersave =
        config.cfg.core.isLaptop;

      dns = "systemd-resolved";
      dhcp = "internal";
    };
  };
}