
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.qnap;
in
{
  options.cfg.services.qnap.enable =
    mkEnableOption "QNAP NAS automount";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cifs-utils ];

    sops.secrets."qnap-username" = {
      sopsFile = ../../secrets/secrets.yaml;
      key = "qnap/username";
    };

    sops.secrets."qnap-password" = {
      sopsFile = ../../secrets/secrets.yaml;
      key = "qnap/password";
    };

    sops.templates."qnap-credentials".content = ''
      username=${config.sops.placeholder."qnap-username"}
      password=${config.sops.placeholder."qnap-password"}
    '';

    fileSystems."/mnt/qnap" = {
      device = "//192.168.0.253/Daten";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."qnap-credentials".path}"
        "vers=3.0"
        "uid=1000"
        "gid=100"
        "file_mode=0664"
        "dir_mode=0775"
        "_netdev"
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
