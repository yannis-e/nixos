{
  self,
  inputs,
  lib,
}:

let
  inherit (lib)
    attrNames
    filterAttrs
    flatten
    genAttrs
    nixosSystem
    ;

  inherit (builtins) readDir;

  hostNames =
    attrNames
      (filterAttrs
        (_: type: type == "directory")
        (readDir ./.));

  mkSystem =
    hostName:
    nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit self inputs hostName;
      };

      modules = flatten [
        self.nixosModules.default
        (self.lib.listRecursive ./${hostName})
      ];
    };
in
genAttrs hostNames mkSystem