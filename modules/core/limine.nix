{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
in
{
  # HACK: limine lets you do a float for the timeout.
  # by default the nix timeout option can only be an int though.
  disabledModules = [ "system/boot/loader/loader.nix" ];
  options = {
    boot.loader.timeout = mkOption {
      default = 5;
      type = types.nullOr types.number;
      description = ''
        Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
      '';
    };
    cfg.core.limine.timeout = mkOption {
      type = types.number;
      default = 5;
      description = ''
        Sets the timeout in seconds for the boot menu to automatically continue.
        Setting to < 1 will also enable quiet boot.
      '';
    };
    cfg.core.limine.bootWin = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether Windows is installed and should be added to the Limine menu.
      '';
    };
  };
  config = {
    boot = {
      initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
        inherit (config.cfg.core.limine) timeout;
        limine = {
          enable = true;
          maxGenerations = 8;
          style = {
            wallpaperStyle = "centered";
            wallpapers =
              let
                imagesDir = "${inputs.walls}/images";
                files = builtins.attrNames (builtins.readDir imagesDir);
              in
                map
                  (file: "${imagesDir}/${file}")
                  (builtins.filter
                    (file:
                      builtins.match ".*\\.(jpg|jpeg|png|webp)$" file != null
                    )
                    files
                  );
            interface = {
              resolution = "max";
              helpHidden = true;
              branding = "Limine Bootloader";
            };
            graphicalTerminal = {
              font.scale = "2x2";
              # don't have any margin around the background colour
              margin = -1;
              marginGradient = -1;
              # darken the wallpapers
              background = "33080808";
              foreground = "B9C1D6";
            };
          };
          extraEntries = lib.optionalString
            config.cfg.core.limine.bootWin
            ''
              /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw\.efi
            '';
          extraConfig = mkIf (config.cfg.core.limine.timeout < 1) ''
            quiet: yes
          '';
        };
      };
    };
  };
}