{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Updated to allow both Steam and NVIDIA proprietary drivers
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
    "nvidia-kernel-modules"
  ];

  # Bootloader Configuration
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale, Timezone, and Console
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Graphics & Window Manager (DWM + Ly Display Manager)
  services.xserver.enable = true;
  services.xserver.windowManager.dwm.enable = true; 
  services.xserver.xkb.layout = "de";
  services.displayManager.ly.enable = true;

  # NVIDIA Graphics Configuration
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
	offload = {
	    enable = true;
	    enableOffloadCmd = true;
	};
	amdgpuBusId = "PCI:6:0:0";
	nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Audio, Power & Storage Services
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;
  services.udisks2.enable = true; # Auto-mount USBs
  services.tlp.enable = true;     # Battery optimization (ignore if on Desktop PC)

  # System Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  # User Configuration
  users.users.yannis = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ]; 
    packages = with pkgs; [
      tree
    ];
  };
  

  ### Steam ###
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  ### System Packages ###
  environment.systemPackages = with pkgs; [
    # Text Editors
    neovim 
    kdePackages.kate

    # Terminal Utilities & Tools
    wget
    git
    github-cli
    st
    dmenu
    xclip
    alsa-utils # Volume control via terminal/shortcuts
    slstatus   # Status bar for DWM

    # File Management
    pcmanfm    # Lightweight graphical file manager

    # Apps & Browsers
    librewolf
    vesktop
  ];

  system.stateVersion = "26.05";
}
