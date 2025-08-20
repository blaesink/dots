{ pkgs, unstable, ...}:
{
  imports = [ ./home.nix ];
  custom = {
    helix = {
      enable = true;
      package = unstable.helix;
    };
    jj.enable = true;
    starship.enable = true;
    zellij.enable = true;
  };
  home.username = "kevin";
  home.homeDirectory = "/home/kevin";
}
