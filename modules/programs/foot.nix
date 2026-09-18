{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.foot;
in
{
  options.cfg.programs.foot.enable = mkEnableOption "foot";

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "foot";
        paths = [ pkgs.foot ];

        # remove desktop files for server and client, using standalone only
        postBuild = ''
          unlink $out/share/applications/footclient.desktop
          unlink $out/share/applications/foot-server.desktop
        '';
      };
      settings = {
        main = {
          font = "monospace:size=13";
          pad = "6x6";
        };
        cursor = {
          style = "beam";
        };
        mouse = {
          hide-when-typing = true;
        };
        colors = {
          alpha = 0.85;
        };
        tweak.font-monospace-warn = false; # slightly faster startup times
        scrollback.lines = 100000;
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "foot.desktop"
      ];
    };
  };
}