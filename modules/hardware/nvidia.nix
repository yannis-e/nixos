{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.cfg.hardware.nvidia;
in
{
  options.cfg.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA";

    prime = {
      enable = mkEnableOption "NVIDIA PRIME hybrid graphics offloading";

      amdgpuBusId = mkOption {
        type = types.str;
        default = "";
      };

      nvidiaBusId = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    # Only enable if you actually use CUDA/AI workloads.
    nixpkgs.config.cudaSupport = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        open = true;
        gsp.enable = true;

        # Important for laptop power saving.
        powerManagement = {
          enable = true;
          finegrained = cfg.prime.enable;
        };

        nvidiaSettings = false;
        branch = "bleeding_edge";

        prime = mkIf cfg.prime.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          amdgpuBusId = cfg.prime.amdgpuBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };

        moduleParams = {
          nvidia = {
            NVreg_UsePageAttributeTable = 1;
            NVreg_EnableResizableBar = 1;
          };
        };
      };
    };

    environment.sessionVariables = {
      # VRR
      __GL_VRR_ALLOWED = "1";

      # Shader cache
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_SIZE = 2 * 1024 * 1024 * 1024;
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";

      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";

      # DXVK / VKD3D
      DXVK_NVAPI_D3D12_NV_SHADER_EXTN = "1";
      VKD3D_CONFIG = "descriptor_heap";
    };

    environment.etc = {
      "nvidia/nvidia-application-profiles-rc.d/50-vram-alloc-fixes.json".text =
        builtins.toJSON {
          rules = [
            {
              pattern = [];
              profile = "No VidMem Reuse";
            }
          ];
        };

      "nvidia/nvidia-application-profiles-rc.d/51-dont-nerf-cuda-perf.json".text =
        builtins.toJSON {
          rules = [
            {
              pattern = [];
              profile = "CudaNoStablePerfLimit";
            }
          ];
        };
    };
  };
}