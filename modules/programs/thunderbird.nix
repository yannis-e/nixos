{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.programs.thunderbird;

in
{
  options.cfg.programs.thunderbird = {
    enable = mkEnableOption "thunderbird";

    defaultClient = mkEnableOption "Use thunderbird as the default email client";
  };

  config = mkIf cfg.enable {
    hj.packages = [
      pkgs.thunderbird
    ];

    xdg.mime = {
      defaultApplications = mkIf cfg.defaultClient {
        "x-scheme-handler/mailto" = mkForce "thunderbird.desktop";
        "message/rfc822" = mkForce "thunderbird.desktop";
      };

      addedAssociations = {
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "message/rfc822" = [ "thunderbird.desktop" ];
      };
    };
  };
}