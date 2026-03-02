{ config, pkgs, ... }:
{
  imports = [
    (import ./home.nix {
      inherit config pkgs;
      jjui=pkgs.jjui;
      jujutsu=pkgs.jujutsu;
    })
  ];
  home.username = "kevin";
  home.homeDirectory = /Users/kevin;
  custom = {
    helix.enable = true;
    jj.enable = true;
    starship.enable = true;
    zellij.enable = true;
  };
}
