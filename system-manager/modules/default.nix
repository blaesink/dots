{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    environment = {
      systemPackages = [
        pkgs.fd
        pkgs.fzf
        pkgs.fish
        pkgs.gcc
        pkgs.gh
        pkgs.git
        pkgs.gnumake
        pkgs.neovim
        pkgs.openssh
        pkgs.ripgrep
        pkgs.rustup
        pkgs.sapling
        pkgs.starship
        pkgs.which
        pkgs.zoxide
      ];
    };

    users.defaultUserShell = pkgs.fish;
  };
}
