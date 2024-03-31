{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }: 
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      pkgs = (import nixpkgs) { inherit system; };
      unstable = import inputs.nixpkgs-unstable { inherit system; };
      # packages = (import ./packages.nix) { inherit pkgs unstable; };
    in rec {
      nixosConfigurations = {
        # NOTE: Right now this uses --impure to get around the <nixos-wsl/modules>        
        wsl = lib.nixosSystem {
          inherit system;
          modules = [ ./wsl/configuration.nix ];
          specialArgs = { inherit inputs unstable; };
        };
      };
    };
}
