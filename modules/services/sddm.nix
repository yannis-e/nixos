{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.sddm;

  sddm-theme = pkgs.sddm-astronaut.override {
    themeConfig = {
      Background = "${inputs.walls}/images/the_artist_s_garden_at_eragny_1970.17.54.jpg";
      
      # Set blur strength (e.g., "1.0", "2.0", "3.0")
      Blur = "1.5";
      
      # Minimal interface settings
      FormPosition = "center";      # Options: "left", "center", "right"
      HaveFormBackground = "false"; # Removes extra card backgrounds for a cleaner look
      FullBlur = "true";           # Blurs the whole screen instead of just a box
    };
  };
in
{
  options.cfg.services.sddm.enable =
    mkEnableOption "SDDM display manager";

  config = mkIf cfg.enable {
    services.xserver.xkb.layout = "de";

    environment.systemPackages = [ sddm-theme ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = [ sddm-theme ];

      settings = {
        General = {
          Numlock = "on";
        };

        Users = {
          MinimumUid = 1000;
          MaximumUid = 60000;
          RememberLastUser = true;
          RememberLastSession = true;
        };
      };
    };
  };
}