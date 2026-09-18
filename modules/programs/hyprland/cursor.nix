{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkIf mkOption types gvariant;

  cfg = config.cfg.programs.hyprland;

  cursors = {
    "Bibata-Original-Classic" = {
      package = pkgs.bibata-cursors;
      theme = "Bibata-Original-Classic";
    };

    "Bibata-Modern-Classic" = {
      package = pkgs.bibata-cursors;
      theme = "Bibata-Modern-Classic";
    };

    "Bibata-Original-Amber" = {
      package = pkgs.bibata-cursors;
      theme = "Bibata-Original-Amber";
    };

    "Bibata-Original-Ice" = {
      package = pkgs.bibata-cursors;
      theme = "Bibata-Original-Ice";
    };
  };

  cursor = cursors.${cfg.cursor};

in
{
  options.cfg.programs.hyprland.cursor = mkOption {
    type = types.enum (builtins.attrNames cursors);
    default = "Bibata-Original-Classic";
    description = "Cursor theme to use.";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = cursor.theme;
      HYPRCURSOR_SIZE = 24;

      XCURSOR_THEME = cursor.theme;
      XCURSOR_SIZE = 24;

      # As a list makes this append instead of overwrite.
      XCURSOR_PATH = [
        "${cursor.package}/share/icons"
      ];
    };

    hj = {
      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI { };
        value = {
          "Icon Theme".Inherits = cursor.theme;
        };
      };

      packages = [
        cursor.package
      ];
    };

    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;

        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = cursor.theme;
            cursor-size = gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
