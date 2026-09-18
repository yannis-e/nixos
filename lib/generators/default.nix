{
  lib,
  inputs,
}:

{
  inherit ((import "${inputs.hyprland}/nix/lib.nix" lib)) toHyprlang;
  inherit ((import ./toHyprconf.nix lib)) toHyprconf;
}