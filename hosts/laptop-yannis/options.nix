{
  cfg = {
    core = {
      username = "yannis";
      kernel.type = "latest";
      isLaptop = true;
      keyLayout = "de";
      limine = {
        timeout = 3;
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
        rnnoise.enable = true;
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
      hyprland.enable = true;
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
      discord.enable = true;
      librewolf.enable = true;
    };
  };
}
