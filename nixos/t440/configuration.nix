{ config, pkgs, inputs, lib, ... }:

let
  unstableTarball = 
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;

in
{
  imports = [
    <nixos-hardware/lenovo/thinkpad/t440p>
    ../base.nix
    ../cachix.nix
    ./displaymanager.nix
    ./hardware-configuration.nix
    ./keyboard.nix
    ../packages.nix
    ../qtile.nix
    ../users.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "IBMPlexMono"]; })
  ];

  # Some projects use devenv, this is to automatically enable the shells.
  programs.direnv.enable = true;


  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  
  environment.systemPackages = with pkgs; [
    brave
    waybar
    wofi
    unstable.eza # `exa` is unmaintained, but currently not in stable packages.
    unstable.git-branchless
    unstable.ugrep
    unstable.wezterm
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # NOTE: networking is enabled in ../base.nix
}
