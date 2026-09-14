{ config, pkgs, ... }:

{
  # Bluetooth setup
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Shows Bluetooth battery status for headsets
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Graphics driver settings
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # Enables hardware video decoding in browsers/VLC
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA & Hybrid GPU offloading
  hardware.nvidia = {
    modesetting.enable = true;

    # Power management (Crucial for laptop battery life during PRIME offload)
    powerManagement.enable = true;
    powerManagement.finegrained = true; # Allows NVIDIA GPU to sleep when offloaded

    # Use proprietary driver (set open = true if on Turing or newer RTX 20xx+)
    open = false;
    nvidiaSettings = true;

    # Use modern production package
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Hybrid GPU Configuration for Wayland / Hyprland
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides `nvidia-offload` helper command
      };
      
      sync.enable = false; # MUST be false for Hyprland / Wayland

      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}