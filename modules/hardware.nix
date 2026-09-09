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
    powerManagement.finegrained = false;

    # Use proprietary driver (recommended for Turing and older; set to true if Ampere/Ada GTX 16xx or newer)
    open = false;
    nvidiaSettings = true;

    # Use modern production package
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Hybrid GPU Configuration
    prime = {
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };
  
      sync.enable = true;

      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}