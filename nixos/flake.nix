{
  description = "Personal nixOS setup for various machines.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }: 
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      unstable = import inputs.nixpkgs-unstable { inherit system; };
    in rec {
      nixosConfigurations = {
        wsl = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./wsl/configuration.nix
            inputs.nixos-wsl.nixosModules.wsl
          ];
          specialArgs = { inherit inputs unstable; };
        };
        kiwano = lib.nixosSystem {
          inherit system;
          modules = [ 
            inputs.disko.nixosModules.disko
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p53
            ./kiwano/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
