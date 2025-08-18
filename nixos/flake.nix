{
  description = "Personal nixOS setup for various machines.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs-latest";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/611c9ea53250f7bb22286b3d26872280a0e608f9";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    copyparty.url = "github:9001/copyparty";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-latest";
    };
  };

  outputs = inputs@{
    nixos-wsl,
    agenix,
    copyparty,
    home-manager,
    ...
  }: 
    let
      system = "x86_64-linux";
      unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true;};
      nixpkgs-latest = import inputs.nixpkgs-latest { inherit system; config.allowUnfree = true; };
    in {
      nixosConfigurations = {
        wsl = inputs.nixpkgs-latest.lib.nixosSystem {
          inherit system;
          modules = [ 
            ./wsl/configuration.nix
            nixos-wsl.nixosModules.default
          ];
          specialArgs = {
            inherit unstable nixpkgs-latest system; 
            packagesType="withFish";
          };
        };
        kiwano = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./kiwano/configuration.nix
            inputs.disko.nixosModules.disko
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p53
            agenix.nixosModules.default
            copyparty.nixosModules.default
          ];
          specialArgs = {
            inherit inputs;
            inherit (inputs) agenix copyparty;
          };
        };
        jackfruit = inputs.nixpkgs-latest.lib.nixosSystem {
          inherit system;
          modules = [
            ./jackfruit/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.kevin = home-manager/jackfruit.nix;
                extraSpecialArgs = { inherit unstable; };
              };
            }
           ];
          specialArgs = {
            inherit nixpkgs-latest unstable system; 
            packagesType="withFish";
          };
        };
      };
    };
}
