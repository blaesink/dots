{ config, pkgs, ...}:
{
  imports = [ ./home.nix ];
  home.username = "kevin";
  home.homeDirectory = "/home/kevin/";
}
