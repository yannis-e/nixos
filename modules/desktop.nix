{ config, pkgs, ... }:

{
  # ─────────────────────────────
  # Notifications
  # ─────────────────────────────
  services.dunst.enable = true;


  # ─────────────────────────────
  # X11 + i3
  # ─────────────────────────────
  services.xserver = {
    enable = true;

    windowManager.i3.enable = true;

    xkb = {
      layout = "de";
      variant = "";
    };
  };

  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+i3";


  # ─────────────────────────────
  # Automatic monitor hotplugging
  # ─────────────────────────────
  services.autorandr = {
    enable = true;

    profiles = {

      # ───────────────────────────
      # Laptop only
      # ───────────────────────────
      "laptop" = {
        fingerprint = {
          eDP-1-0 = "00ffffffffffff0009e5fd0c000000001d210104a52213780395b5965d5a92291e505400000001010101010101010101010101010101ed8980a5703860403020350058c21000001a783980a5703860403020350058c21000001a00000000000000000000000000000000000000000002000d36ff0a3c962f122c96000000019c70207902002501093a63053a63053090808100106f1a0000030130900000535153519000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc90";
        };

        config = {
          eDP-1-0 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "144.00";
          };
        };
      };


      # ───────────────────────────
      # Laptop + external HDMI
      # ───────────────────────────
      "home" = {
        fingerprint = {
          eDP-1-0 = "00ffffffffffff0009e5fd0c000000001d210104a52213780395b5965d5a92291e505400000001010101010101010101010101010101ed8980a5703860403020350058c21000001a783980a5703860403020350058c21000001a00000000000000000000000000000000000000000002000d36ff0a3c962f122c96000000019c70207902002501093a63053a63053090808100106f1a0000030130900000535153519000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc90";
          HDMI-0 = "00ffffffffffff0006b3d124404a0000241e010380351e782acf75a355509e250d5054bfef00d1c0b30095008180814081c0714f0101023a801871382d40582c45000f282100001e000000ff004c394c4d54463031393030380a000000fd00304b185412000a202020202020000000fc00415355532056413234450a2020010602032b714f0102031112130414050e0f1d1e1f90230917078301000065030c001000681a00000101304be66842806a70382740082098040f282100001a011d007251d01e206e2855000f282100001e011d00bc52d01e20b82855400f282100001e8c0ad090204031200c4055000f282100001800000000000000000000000073";
        };

        config = {
          eDP-1-0 = {
            enable = true;
            position = "0x1080";
            mode = "1920x1080";
            rate = "144.00";
          };

          HDMI-0 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
    };

    hooks = {
      postswitch = {
        "i3-reload" = "${pkgs.i3}/bin/i3-msg restart";
      };
    };
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", TAG+="systemd", ENV{SYSTEMD_WANTS}="autorandr-hotplug.service"
  '';

  systemd.services.autorandr-hotplug = {
    description = "Autorandr monitor hotplug";

    serviceConfig = {
      Type = "oneshot";
      User = "yannis";

      Environment = [
        "DISPLAY=:0"
        "XAUTHORITY=/run/user/1000/lyxauth"
      ];

      ExecStart = "${pkgs.autorandr}/bin/autorandr --change";
    };
  };

  # ─────────────────────────────
  # Picom
  # ─────────────────────────────
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


  # ─────────────────────────────
  # Fonts
  # ─────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}