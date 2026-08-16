{ pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Network and hostname
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "eno1" "wlo1" ];
    allowedTCPPorts = [ 53317 ]; # LocalSend TCP
    allowedUDPPorts = [ 53317 ]; # LocalSend UDP
  };

  # Swap configuration for high-memory workloads
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8192; # 8 GB Swap
  } ];

  # Time, locale, and console keymap
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Audio and peripheral services
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;
  services.udisks2.enable = true;
  services.tlp.enable = true;

  # Udev rules for hardware programming
  services.udev.packages = [ pkgs.openocd ];
  services.udev.extraRules =
    let rulePath = /home/yannis/.arduino15/packages/STMicroelectronics/tools/xpack-openocd/0.12.0-6/openocd/contrib/60-openocd.rules;
    in if builtins.pathExists rulePath then builtins.readFile rulePath else "";

  # Dynamic linker support for non-nix binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glibc
    ];
  };

  # Global Nixpkgs options
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  # System state version
  system.stateVersion = "26.05";
}