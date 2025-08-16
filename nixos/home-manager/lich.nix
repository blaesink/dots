{ config, pkgs, ...}:
{
  imports = [ ./home.nix ];
  home.username = "lich";
  home.homeDirectory = "/home/lich/";
}
