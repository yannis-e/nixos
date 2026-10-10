
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkAliasOptionModule;
  cfg = config.cfg.security.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    (mkAliasOptionModule
      [ "modules" "security" "sops" "secrets" ]
      [ "sops" "secrets" ])
  ];

  options.cfg.security.sops.enable =
    mkEnableOption "Enable sops-nix secret management";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };
}
