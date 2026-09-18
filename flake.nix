{
  description = "Yannis' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walls = {
      url = "gitlab:fazzi/walls";
      flake = false;
      };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    KvLibadwaita = {
      url = "github:GabePoel/KvLibadwaita";
      flake = false;
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:4evy/nixcord";
  };

  outputs =
    { self, nixpkgs, hjem, ... }@inputs:
    let
      inherit (nixpkgs) lib;
    in
    {
      lib = import ./lib {
        inherit lib inputs;
      };

      nixosModules.default =
        self.lib.listRecursive ./modules;

      nixosConfigurations =
        import ./hosts {
          inherit self inputs lib;
        };
    };
}