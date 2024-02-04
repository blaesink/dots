{ config, pkgs, ...}:
{
  imports = [ ./home.nix ];
  home.username = "nixos";
  home.homeDirectory = "/home/nixos/";
}
