{ config, pkgs, ...}:
{
  imports = [ ./home.nix ];
  home.username = "kevin";
  home.homeDirectory = "/home/kevin/";
  home.file.".config/fish/television.fish".source = dotfiles/fish/television.fish;
  home.file.".config/starship.toml".source = dotfiles/starship/config.toml;
}
