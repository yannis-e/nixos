{
  pkgs,
  self,
  inputs,
  ...
}:

{
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        libnotify
        nicotine-plus

        kicad
        pv
        vcv-rack
        spotify
        gcc
        gnumake
        python3
        usbutils
        openocd

        self.packages.${pkgs.stdenv.hostPlatform.system}.wall-picker
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    time.timeZone = "Europe/Berlin";
  };
}