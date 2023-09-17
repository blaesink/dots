{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    environment = {
      systemPackages = [
        pkgs.exa
        pkgs.fd
        pkgs.fish
        pkgs.fzy
        pkgs.gcc
        pkgs.gh # Required by sapling to use github.
        pkgs.git
        pkgs.gnumake
        pkgs.helix
        pkgs.neovim
        pkgs.openssh
        pkgs.ripgrep
        pkgs.rustup
        pkgs.sapling
        pkgs.starship
        pkgs.which
        pkgs.zoxide
        pkgs.zellij
      ];
    };
  };
}
