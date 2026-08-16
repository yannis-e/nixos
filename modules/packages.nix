{ pkgs, ... }:

{
  # Steam integration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # Wrap Steam so all games automatically inherit nvidia-offload environment variables
    package = pkgs.steam.override {
      extraEnv = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };

  # Gamemode support
  programs.gamemode.enable = true;

  # Installed system utilities and applications
  environment.systemPackages = with pkgs; [
    # Desktop environment & UI tools
    alacritty
    brightnessctl
    dmenu
    feh
    i3blocks
    maim
    xclip
    playerctl

    # File management & compression
    pcmanfm
    stow
    unzip

    # Audio & hardware utilities
    alsa-utils
    bluetui
    wiremix
    xp-pen-deco-01-v2-driver

    # CLI development & system monitoring tools
    btop
    fzf
    gcc
    git
    github-cli
    jdk
    neovim
    nodejs
    pnpm
    python3
    wget

    # Desktop productivity & engineering
    arduino-ide
    blender
    kdePackages.kate
    kdePackages.kdenlive
    kicad
    krita
    orca-slicer
    vscodium

    # Browsers & communication
    floorp-bin
    librewolf
    localsend
    vesktop

    # Game launchers
    heroic
    prismlauncher
  ];
}