{ config, pkgs, ... }:

{
  # ────────────────────────────────────────────────────────────────────────────
  # Notifications
  # ────────────────────────────────────────────────────────────────────────────
  services.dunst.enable = true;
  services.systembus-notify.enable = true; # battery etc. via power-profiles-daemon

  # ────────────────────────────────────────────────────────────────────────────
  # XDG portals (screen sharing / screenshots)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ────────────────────────────────────────────────────────────────────────────
  # Hyprland (Wayland)
  # ────────────────────────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = false; # standard Hyprland session management
    xwayland.enable = true; # needed by e.g. orca-slicer, some Java tools
  };

  # Screen lock: hyprlock + hypridle (PAM service is wired up by the module)
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  # GNOME-keyring style authentication dialogs for e.g. Steam, browsers
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Status bar
  programs.waybar.enable = true;

  # ────────────────────────────────────────────────────────────────────────────
  # Display manager: ly (keeps your current login screen)
  # ────────────────────────────────────────────────────────────────────────────
  services.displayManager.ly = {
    enable = true;
    x11Support = false; # pure Wayland setup
    settings = {
      animation = "matrix";
      hide_borders = true;
    };
  };
  services.displayManager.defaultSession = "hyprland";

  # ────────────────────────────────────────────────────────────────────────────
  # Fonts
  # ────────────────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}