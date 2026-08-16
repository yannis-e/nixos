{ pkgs, ... }:

{
  # Steam integration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Gamemode support
  programs.gamemode.enable = true;

  # Installed system utilities and applications
  environment.systemPackages = with pkgs; [
    # Desktop environment & UI tools
    alacritty
    dmenu
    feh
    i3blocks
    xclip

    # File management & compression
    pcmanfm
    stow
    unzip

    # Audio & hardware utilities
    alsa-utils
    bluetui
    wiremix
    xp-pen-deco-01-v2-driver

    # CLI development tools
    git
    github-cli
    jdk
    gcc
    python3
    nodejs
    pnpm
    neovim
    wget

    # Desktop productivity & engineering
    arduino-ide
    vscodium
    blender
    kdePackages.kate
    kdePackages.kdenlive
    orca-slicer
    sunvox
    kicad
    krita

    # Browsers & communication
    librewolf
    floorp-bin
    localsend
    vesktop

    # Game launchers
    heroic
    prismlauncher
  ];
}