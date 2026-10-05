{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types mkIf mkAfter getExe;

  cfg = config.cfg.programs.fastfetch;
in
{
  options.cfg.programs.fastfetch = {
    enable = mkEnableOption "fastfetch";

    shellIntegration = mkOption {
      type = types.bool;
      default = false;
      description = "Run fastfetch when the shell starts.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.fastfetch ];

      xdg.config.files."fastfetch/config.jsonc" = {
        generator = lib.generators.toJSON { };

        value = {
          general.detectVersion = false;

          display.separator = " : ";

          logo = {
            type = "builtin";
            source = "nixos";
          };

          modules = [
            {
              type = "title";
              format = "{1}@{2}";
            }
            {
              type = "os";
              format = "{2}";
            }
            {
              type = "kernel";
            }
            {
              type = "uptime";
            }
            {
              type = "desktop";
              format = "{2}";
            }
            {
              type = "terminal";
            }
            "break"
            {
              type = "cpu";
              format = "{1} ({4} cores)";
            }
            {
              type = "gpu";
              format = "{2}";
            }
            {
              type = "memory";
              format = "{1}";
            }
            {
              type = "disk";
              folders = [ "/" ];
              format = "{1} / {2} ({3})";
            }
          ];
        };
      };
    };

    programs.zsh = mkIf cfg.shellIntegration {
      interactiveShellInit = mkAfter ''
        if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
          ${getExe pkgs.fastfetch}
          printf '\033[3A'
        fi
      '';
    };
  };
}
