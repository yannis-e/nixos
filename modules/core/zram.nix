{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.cfg.core.zram;
in
{
  options.cfg.core.zram = {
    enable = mkEnableOption "zram swap";

    memoryPercent = mkOption {
      type = types.ints.positive;
      default = 100;
      description = "Size of the zram swap device as a percentage of RAM.";
    };

    swappiness = mkOption {
      type = types.ints.between 0 200;
      default = 100;
      description = "Kernel swappiness when using zram.";
    };
  };

  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = cfg.memoryPercent;

      algorithm =  
        #16GB Ram = zstd / 32GB Ram = lz4
        if config.cfg.core.isLaptop
        then "zstd(level=-1)"
        else "lz4";
    };

    boot = {
      kernelParams = [
        "zswap.enabled=0"
      ];

      kernel.sysctl = {
        "vm.swappiness" = cfg.swappiness;
        "vm.page-cluster" = 0;
      };
    };
  };
}