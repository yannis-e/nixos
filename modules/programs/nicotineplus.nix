{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cfg.programs.nicotine-plus;
in
{
  options.cfg.programs.nicotine-plus = {
    enable = mkEnableOption "Nicotine+ Soulseek client";
  };

  config = mkIf cfg.enable {
    hj.packages = [
      pkgs.nicotine-plus
    ];

    networking.firewall = {
      allowedTCPPorts = [ 2234 ];
    };
  };
}