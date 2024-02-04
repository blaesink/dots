# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

let
  unstableTarball = 
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  packages = (import ../packages.nix) { inherit pkgs; };
  systemPackages = packages.environment.systemPackages;
in
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];

  nix.settings.trusted-users = [ "root" "nixos" ]; # Allow for using `cachix use devenv`.
  
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  users.users.nixos = {
    isNormalUser = true;
    description = "Kevin WSL Account";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
 
  programs.direnv.enable = true;
  programs.fish.enable = true;
 

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  
  environment.systemPackages = with pkgs; [
    unstable.eza
    (import (fetchTarball https://install.devenv.sh/latest)).default # devenv from cachix    
  ] ++ systemPackages;
}
