{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.pipewire;
in
{
  options.cfg.services.pipewire.enable = mkEnableOption "pipewire";
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.extraConfig = {
      };
    };
    hj.packages = with pkgs; [
      qpwgraph
      pwvucontrol
      alsa-utils
    ];
    users.users.${config.cfg.core.username}.extraGroups = [
      "audio"
      "pipewire"
    ];
  };
}