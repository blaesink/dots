{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:nix-darwin/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-casks = {
      url = "github:atahanyorganci/nix-casks/archive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-casks, ... }:
  let
    system = "aarch64-darwin";
    configuration = { pkgs, ... }:
    let
      nixcasks = nix-casks.packages.${pkgs.system};
    in {
        imports = [
          (import ./container.nix { container = pkgs.container; })
          ./unfree.nix
          ./services/syncthing.nix
          (import ../packages.nix { inherit pkgs; unstable = pkgs; })
        ];
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          with pkgs; [
            container # macos' new container system. currently at 0.9 but I'll pin it later
            codex
            cloudflared
            ghostty-bin # macos can't be built just yet
            jjui # NOTE: planning to bump to 0.10.x when I can. Would just need to point to the new version on GH.
            obsidian # unfree
          ];

        environment.shells = [ pkgs.fish ];

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        programs.fish.enable = true; 
        programs.direnv.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        system.primaryUser = "kevin";

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        services.syncthing.enable = true; 
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };
  };
}
