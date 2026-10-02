{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkEnableOption;
in
{
  options.cfg.programs.smoothScroll = {
    enable = mkEnableOption "smooth scrolling" // {
      default = true;
    };
  };

  config = {
    programs = {
      command-not-found.enable = false;
    };

    # Standardpakete nicht entfernen
    # environment.defaultPackages = mkDefault [ ];
  };
}