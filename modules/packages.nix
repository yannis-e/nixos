{ pkgs, ... }:

{
  # ============================================================================
  # HARDWARE & SYSTEM MODULES
  # ============================================================================

  # Enable OpenTabletDriver native hardware daemon
  hardware.opentabletdriver.enable = true;

  # Steam configuration with Nvidia Prime offloading
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    package = pkgs.steam.override {
      extraEnv = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };

  # GameMode daemon for dynamic system performance tuning
  programs.gamemode.enable = true;

  # --- Thunar (Trash, USB Auto-mounting, Settings & Thumbnails) ---
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true; # Saves Thunar preferences across reboots
  services.gvfs.enable = true;   # Required for Trash bin and mounting USB drives
  services.tumbler.enable = true; # Thumbnail preview generation daemon

  # ============================================================================
  # ENVIRONMENT PACKAGES
  # ============================================================================

  environment.systemPackages = with pkgs; [

    # --- Desktop, Window Manager & Compositing Utilities ---
    alacritty                 # GPU-accelerated terminal emulator
    brightnessctl             # Screen brightness control
    dmenu                     # Dynamic menu launcher for X11
    dunst                     # Desktop notification daemon (lightweight)
    feh                       # Lightweight image viewer & wallpaper setter
    i3blocks                  # Modular status bar for i3/sway
    i3lock-color              # Highly customizable i3 screen locker
    maim                      # Command-line screenshot utility
    picom                     # X11 compositor (prevents tearing, enables transparency)
    playerctl                 # Media player CLI controller
    xclip                     # X11 clipboard management

    # --- File Management & System Tools ---
    stow                      # Symlink farm manager (dotfiles)
    unzip                     # Extraction tool for zip archives

    # --- Audio, Hardware & Drivers ---
    alsa-utils                # ALSA audio control utilities (alsamixer)
    bluetui                   # TUI for Bluetooth management
    impala                    # TUI Wi-Fi manager
    pavucontrol               # Graphical audio mixer & sink switcher (replaces wiremix)
    autorandr
    arandr

    # --- Development Tools & Runtimes ---
    gcc                       # C/C++ compiler collection
    jdk                       # Java Development Kit
    nodejs                    # Node.js JavaScript runtime
    pnpm                      # Fast, disk space efficient package manager
    python3                   # Python 3 interpreter

    # --- CLI & System Monitoring ---
    btop                      # Resource monitor dashboard
    fastfetch                 # Hardware and system info summary tool
    fzf                       # Command-line fuzzy finder
    git                       # Distributed version control system
    github-cli                # GitHub integration for terminal
    neovim                    # Extensible text editor
    ripgrep                   # High-performance search tool (grep alternative)
    wget                      # Network file retriever

    # --- Creative & Engineering ---
    arduino-ide               # IDE for Arduino microcontroller programming
    audacity                  # Audio editor and recorder
    blender                   # 3D creation suite
    kdePackages.kate          # Advanced text editor
    kdePackages.kdenlive      # Video editing software
    kicad                     # Electronics design automation suite
    krita                     # Digital painting program
    mixxx                     # Open-source DJ software
    orca-slicer               # 3D printing slicer

    # --- Productivity & Communication ---
    vscodium                  # Telemetry-free VS Code build
    spotify                   # Music streaming client
    floorp-bin                # Privacy-focused Firefox fork
    librewolf                 # Hardened Firefox fork
    localsend                 # Open-source local file sharing
    vesktop                   # Custom Discord client with Vencord
    thunderbird               # Email client

    # --- Game Launchers ---
    heroic                    # Launcher for Epic, GOG, and Prime Gaming
    prismlauncher             # Open-source Minecraft launcher
  ];
}