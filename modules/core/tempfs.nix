{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.cfg.core.tmpfs;
in
{
  options.cfg.core.tmpfs = {
    enable = mkEnableOption "tmpfs for /tmp";

    size = mkOption {
      type = types.str;
      default = "50%";
      description = "Maximum size of /tmp as a percentage or size.";
    };
  };

  config = mkIf cfg.enable {
    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = cfg.size;
    };
  };
}