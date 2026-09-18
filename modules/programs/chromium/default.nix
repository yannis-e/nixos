{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    optionals
    concatStringsSep
    ;
  cfg = config.cfg.programs.chromium;
  disableFeatures = [
    # stop allowing chromium / electron to adjust your mic gain
    "WebRtcAllowInputVolumeAdjustment"
  ];
  enableFeatures = [
    # vaapi info: https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md
    "AcceleratedVideoDecodeLinuxGL"
    "AcceleratedVideoDecodeLinuxZeroCopyGL"
    "AcceleratedVideoEncoder"
    "VaapiOnNvidiaGPUs"
    "WaylandLinuxDrmSyncobj" # fix flickering on nvidia
    "MiddleClickAutoscroll"
  ];

  commonArgs = [
    # hdr, wcg
    "--enable-experimental-web-platform-features"
  ]
  ++ optionals (enableFeatures != [ ]) [
    "--enable-features=${concatStringsSep "," enableFeatures}"
  ]
  ++ optionals (disableFeatures != [ ]) [
    "--disable-features=${concatStringsSep "," disableFeatures}"
  ]
  ++ optionals (!(config.cfg.programs ? smoothScroll && config.cfg.programs.smoothScroll.enable)) [
    "--disable-smooth-scrolling"
  ];

  commandLineArgs = [
    "--extension-mime-request-handling=always-prompt-for-install"
  ]
  ++ commonArgs;
in
{
  options.cfg.programs.chromium = {
    enable = mkEnableOption "chromium";
    commonArgs = mkOption {
      type = types.listOf types.str;
      default = commonArgs;
      internal = true;
      description = "Common args for chromium and electron apps";
    };
  };

  config = {
    cfg.programs.chromium.commonArgs = commonArgs;

    hj = mkIf cfg.enable {
      packages = [
        (pkgs.ungoogled-chromium.override {
          inherit commandLineArgs;
        })
      ];
    };
  };
}