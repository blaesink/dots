{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    <nixos-hardware/lenovo/thinkpad/t440p>
    ../base.nix
    ../packages.nix
    ../qtile.nix
    ../users.nix
    ./displaymanager.nix
    ./hardware-configuration.nix
    ./keyboard.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";

  networking.hostName = "nixos"; # Define your hostname.
  # NOTE: networking is enabled in ../base.nix
}
