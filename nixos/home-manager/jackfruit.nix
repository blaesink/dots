{...}:
{
  imports = [ ./home.nix ];
  custom = {
    jj.enable = true;
    starship.enable = true;
    zellij.enable = true;
  };
  home.username = "kevin";
  home.homeDirectory = "/home/kevin";
}
