{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    optionalAttrs
    ;

  cfg = config.cfg.programs.hyprland;

  # Greift nur sicher auf inputs.hyprland zu, wenn useGit aktiviert IST UND das Input existiert
  hyprlandSet =
    if cfg.useGit && (inputs ? hyprland) then
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}
    else
      pkgs;
in
{
  options.cfg.programs = {
    hyprland = {
      enable = mkEnableOption "Hyprland";
      
      useGit = mkOption {
        type = types.bool;
        default = false;
        description = "Use Hyprland package from flake inputs instead of nixpkgs.";
      };

      withUWSM = mkOption {
        type = types.bool;
        default = true;
      };

      defaultMonitor = mkOption {
        type = types.str;
        default = "DP-1";
        description = "Sets the default monitor for hypr*";
      };

      secondaryMonitor = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Sets the secondary monitor for hypr*.";
      };

      extraHlConfig = mkOption {
        type = types.attrsOf types.anything;
        default = { }; # <-- WICHTIG: Verhindert evaluation error "definition missing"
        description = "Extra configuration for hl.config";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Extra configuration for Hyprland";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandSet.hyprland;
      withUWSM = cfg.withUWSM;
    };
  };
}