{
  cfg = {
    core = {
      username = "yannis";
      kernel.type = "latest";
      isLaptop = true;
      keyLayout = "de";
      limine = {
        timeout = 0;
        bootWin = false;
      };
      networkmanager.enable = true;
    };

    hardware = {
      amdgpu.enable = true;
      nvidia = {
        enable = true;
        prime = {
          enable = true;
          amdgpuBusId = "PCI:6:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      bluetooth.enable = true;
      scanning.enable = true;
    };

    services = {
      pipewire = {
        enable = true;
        rnnoise = {
          enable = true;
          vadThreshold = 97;
          vadGracePeriod = 50;
          retroactiveVadGrace = 0;
        };
      };
      cliphist.enable = true;
      dunst.enable = true;
      mate-polkit.enable = true;
      libvirt.enable = true;
      lact.enable = true;
      greetd.enable = true;
      mpd = {
        enable = true;
        notification.enable = true;
      };
      hyprpaper.enable = true;
    };

    programs = {
      smoothScroll.enable = false;
      hyprland = {
        enable = true;
        withUWSM = true;
        cursor = "Bibata-Original-Ice";
      };
      ncmpcpp.enable = true;
      fuzzel.enable = true;
      codium.enable = true;
      foot.enable = true;
      chromium.enable = true;
      nh.enable = true;
      git = {
        enable = true;
        name = "yannis";
        email = "yannis.estermann@outlook.com";
      };
      zsh.enable = true;
      librewolf.enable = true;
      zoxide.enable = true;
      fastfetch = {
        enable = true;
        shellIntegration = true;
        icon = "snoopy";
      };
      bottom.enable = true;
      mpv.enable = true;
      prismlauncher.enable = true;
      thunar.enable = true;
      steam.enable = true;
      mangohud.enable = true;
      proton-ge = {
        enable = true;
        nativeWayland = true;
      };
      thunderbird = {
        enable = true;
        defaultClient = true;
      };
      localsend.enable = true;
    };
  };
}
