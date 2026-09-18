{ pkgs, ... }: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
      ];
    };
    boot.loader.limine.secureBoot.enable = true;
    time.timeZone = "Europe/Berlin";
    console.keyMap = "de";
  };
}