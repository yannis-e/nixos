{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkDefault
    mkIf
    ;
in
{
  options = {
    cfg.core = {
      isLaptop = mkEnableOption "laptop";
      keyLayout = mkOption {
        type = types.str;
        default = "us";
        description = "Sets the console keyboard layout";
      };
    };
  };
  config = {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = [ pkgs.terminus_font ];
      keyMap = config.cfg.core.keyLayout;
    };

    time.timeZone = mkDefault "Europe/London";
    i18n.defaultLocale = mkDefault "en_GB.UTF-8";

    boot = {
      plymouth = {
        enable = true;
        theme = "bgrt";
      };

      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
        "udev.log_level=3"
        "vt.global_cursor_default=0"

        "fbcon=font:TER16x32"

        "nowatchdog"
        "mitigations=off"

        (mkIf config.cfg.core.isLaptop "amd_dynamic_epp=enable")
      ];
    };
  };
}