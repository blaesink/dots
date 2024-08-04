{ config, lib, pkgs, modulesPath, ... }: 
let
  commonUserArgs = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU Kevin Blaesing <kevin.blaesing@gmail.com>"
    ];
  };
in {
  imports = [ ../base.nix ];

  system.stateVersion = "24.05"; # Don't change this!

  # Only using ethernet.
  networking.networkmanager.enable = false;
  networking.useDHCP = true;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  users.users.sunshine = commonUserArgs // {
    isNormalUser = true;
    description = "Sunshine user account";
  };

  services.tlp.settings = {
    # Keep battery from being fully charged to prolong its lifespan.
    START_CHARGE_THRESH_BAT0 = 65;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };
  
}

