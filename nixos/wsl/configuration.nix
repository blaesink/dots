# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, unstable, ... }: 
let
  packages = import (../packages.nix) { inherit pkgs unstable; };
  systemPackages = packages.environment.systemPackages;
in {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];
  nix.settings = {
    substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
    trusted-users = [ "root" "nixos" ]; # Allow for using `cachix use devenv`.
    experimental-features = [ "nix-command" "flakes" ];
  };
  
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
 
  system.stateVersion = "23.11"; # Did you read the comment?

  environment.systemPackages = systemPackages;
}
