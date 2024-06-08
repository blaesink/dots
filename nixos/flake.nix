{
  description = "Personal nixOS setup for various machines.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs-latest";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-wsl,
    nixpkgs-latest,
    nixpkgs-unstable,
    ...
  }: 
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      unstable = import inputs.nixpkgs-unstable { inherit system; };
      nixpkgs-latest = import inputs.nixpkgs-latest { inherit system; };
    in rec {
      nixosConfigurations = {
        wsl = inputs.nixpkgs-latest.lib.nixosSystem {
          inherit system;
          modules = [ 
            ./wsl/configuration.nix
            nixos-wsl.nixosModules.default
          ];
          specialArgs = {
            inherit unstable nixpkgs-latest system; 
          };
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
