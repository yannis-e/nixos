{ config, lib, pkgs, ... }:

{
  # Import hardware profile and modular sub-configs
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/packages.nix
    ./modules/users.nix
  ];
}