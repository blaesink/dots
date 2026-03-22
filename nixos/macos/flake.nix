{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:nix-darwin/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, ... }:
  let
    system = "aarch64-darwin";
    configuration = { pkgs, ... }:
    {
        imports = [
          ./unfree.nix
          ./services/colima.nix
          ./services/syncthing.nix
          (import ../packages.nix { inherit pkgs; unstable = pkgs; })
        ];
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          with pkgs; [
            cloudflared
            colima
            dive
            docker
            docker-buildx
            docker-compose
            gh          # github cli
            ghostty-bin # macos can't be built just yet
            lima
            obsidian    # unfree
            windsurf
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

        homebrew = {
          enable = true;
          brews = [];
          casks = [
            "1password"
            "zen"
            "codex"
            "microsoft-teams"
            "slack"
            "windows-app"
            "claude-code"
          ];
        };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "kevin";
          };
        }
      ];
    };
  };
}
