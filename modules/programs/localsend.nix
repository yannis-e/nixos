{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.localsend;
in
{
  options.cfg.programs.localsend = {
    enable = mkEnableOption "LocalSend";
  };

  config = mkIf cfg.enable {
    hj.packages = [
      pkgs.localsend
    ];

    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };
}