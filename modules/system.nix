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
  networking.wireless.enable = false;
  networking.networkmanager.enable = false;
  services.resolved.enable = true;
  
  # iwd configuration
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
        # Tell iwd to use systemd-resolved for DNS
        NameResolvingService = "systemd";
        # Correct option to disable MAC randomization
        AddressRandomization = "disabled"; 
      };
      IPv6 = {
        Enabled = true;
      };
      Settings = {
        AutoConnect = true;
      };
      DriverQuirks = {
        PowerSaveDisable = "*";
      };
    };
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "eno1" "wlo1" ];
    allowedTCPPorts = [ 53317 ]; # LocalSend TCP
    allowedUDPPorts = [ 53317 ]; # LocalSend UDP
  };

  # Nix daemon settings & experimental features
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Dynamic ZRAM for high-memory workloads
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Uses up to 50% of total RAM as compressed swap
  };

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
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # Improves compatibility for Linux audio production
  };
  security.rtkit.enable = true;
  services.libinput.enable = true;
  services.udisks2.enable = true;
  services.tlp.enable = true;


  # Udev rules for hardware programming
  services.udev.packages = [ pkgs.openocd ];

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
