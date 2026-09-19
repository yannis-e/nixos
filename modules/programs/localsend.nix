{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.localsend;
in
{
  options.cfg.programs.localsend = {
    enable = mkEnableOption "localsend";
  };

  config = mkIf cfg.enable {
    hj.packages = [
      pkgs.localsend
    ];

    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };

    systemd.user.services.localsend = {
      Unit = {
        Description = "LocalSend";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.localsend}/bin/localsend --hidden";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}