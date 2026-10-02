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
        fd
        kicad
        pv
        spotify
        gcc
        gnumake
        python3
        usbutils
        anki
        discord
        kdePackages.francis
        eclipses.eclipse-java
        kdePackages.kdenlive
        (pkgs.writeShellScriptBin "arduino-ide" ''
          exec ${pkgs.arduino-ide}/bin/arduino-ide --ozone-platform=x11 "$@"
        '')

        self.packages.${pkgs.stdenv.hostPlatform.system}.wall-picker
        inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    time.timeZone = "Europe/Berlin";
  };
}