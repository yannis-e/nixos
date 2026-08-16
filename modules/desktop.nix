{ pkgs, ... }:

{
  # X11 Window Manager & Display Manager
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.xkb.layout = "de";
  services.displayManager.ly.enable = true;

  # Picom Compositor with blur and transparency rules
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    activeOpacity = 0.95;
    inactiveOpacity = 0.85;

    settings = {
      blur = {
        method = "dual_kawase";
        strength = 3;
      };
      blur-background = true;
      blur-background-frame = true;

      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
        "class_g = 'slop'"
      ];

      opacity-rule = [
        "90:class_g = 'Alacritty'"
        "100:_NET_WM_STATE@:32a *= '_NET_WM_STATE_FULLSCREEN'"
        "100:class_g = 'Firefox'"
        "100:class_g = 'Brave-browser'"
        "100:class_g = 'vlc'"
      ];
    };
  };

  # System font configuration
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}