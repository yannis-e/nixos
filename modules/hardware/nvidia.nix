{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.cfg.hardware.nvidia;
in
{
  options.cfg.hardware.nvidia = {
    enable = mkEnableOption "nvidia";

    # Added Options for PRIME Hybrid Graphics
    prime = {
      enable = mkEnableOption "NVIDIA PRIME hybrid graphics offloading";
      amdgpuBusId = mkOption {
        type = types.str;
        default = "";
        description = "PCI Bus ID for the AMD iGPU (e.g. PCI:5:0:0)";
      };
      nvidiaBusId = mkOption {
        type = types.str;
        default = "";
        description = "PCI Bus ID for the NVIDIA dGPU (e.g. PCI:1:0:0)";
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        open = true;
        gsp.enable = config.hardware.nvidia.open;
        powerManagement = {
          enable = true;
          # Enables dynamic power management (turns off dGPU when idle)
          finegrained = cfg.prime.enable; 
        };
        nvidiaSettings = false;
        branch = "bleeding_edge";

        # Integrate PRIME Offload Configuration
        prime = mkIf cfg.prime.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true; # Adds 'nvidia-offload' helper script
          };
          amdgpuBusId = cfg.prime.amdgpuBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };

        moduleParams = {
          nvidia = {
            NVreg_UsePageAttributeTable = 1;
            NVreg_EnableResizableBar = 1;
            "NVreg_RegistryDwords=RmEnableAggressiveVblank" = 1;
            "NVreg_RegistryDwords=RmDisableDisplayGlitchPerfLimit" = 1;
          };
          nvidia-modeset.disable_vrr_memclk_switch = 1;
        };
      };
    };

    environment = {
      sessionVariables = {
        __GL_SYNC_TO_VBLANK = "0";
        __GL_VRR_ALLOWED = "1";
        __GL_MaxFramesAllowed = "1";
        __GL_SHADER_DISK_CACHE = 1;
        __GL_SHADER_DISK_CACHE_SIZE = 12 * 1024 * 1024 * 1024;
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/current-system/etc/egl/egl_external_platform.d";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        CUDA_DISABLE_PERF_BOOST = 1;
        DXVK_NVAPI_D3D12_NV_SHADER_EXTN = 1;
        VKD3D_CONFIG = "descriptor_heap";
      };
      etc = {
        "nvidia/nvidia-application-profiles-rc.d/50-vram-alloc-fixes.json".text = builtins.toJSON {
          rules = [
            {
              pattern = [ ];
              profile = "No VidMem Reuse";
            }
          ];
        };
        "nvidia/nvidia-application-profiles-rc.d/51-dont-nerf-cuda-perf.json".text = builtins.toJSON {
          rules = [
            {
              pattern = [ ];
              profile = "CudaNoStablePerfLimit";
            }
          ];
        };
      };
    };

    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}