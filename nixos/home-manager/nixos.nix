{ config, pkgs, ...}:
{
  imports = [ ./home.nix ];
  home.username = "nixos";
  home.homeDirectory = "/home/nixos/";

  home.file.".ssh/config".source = dotfiles/ssh/config;
}
