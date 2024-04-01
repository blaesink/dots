# Kiwano Configuration.
# === Specs ===
# Machine: Lenovo P53
# Memory:  64GB
# CPU:     Intel 8950HX
# GPU:     NVIDIA Quadro T1000 Mobile
# =============

{ config, lib, pkgs, unstable, modulesPath, ... }: 
let
  commonUserArgs = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU Kevin Blaesing <kevin.blaesing@gmail.com>"
    ];
  };
in {
  imports = [ 
    (modulesPath + "/profiles/headless.nix")
    ../base.nix  # Networking, etc.
    ./disk-config.nix # For use in nixos-anywhere initial provisioning.
    ./hardware-configuration.nix
    ./samba.nix # Enable SMB sharing.
  ];
  system.stateVersion = "23.11"; # Don't change this!
  networking.hostName = "kiwano";

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "consoleblank=60" # turn off screen after a minute
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users = builtins.mapAttrs (_: usr: usr // commonUserArgs) {
    kiwano = {
      isNormalUser = true;
      description = "Kiwano user account.";
    };
    kevin = {
      isNormalUser = true;
      description = "Kevin Area 51 account.";
    };
    root = {};
  };

  # === begin enable NVIDIA GPU ===
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-persistenced"
    ];

  hardware.nvidia = {
    modesetting.enable = true; # required

    # `open` is only available for Turing and later, of which this machine does not have.
    open = false;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      reverseSync.enable = true; # Experimental, but a mix of `sync` and `offload`.
      intelBusId = "pci:0:2:0";
      nvidiaBusId = "pci:1:0:0";
    };
  };
  # === end enable NVIDIA GPU ===

  # Don't suspend because the lid is closed.
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  services.tlp.settings = {
    # Keep battery from being fully charged to prolong its lifespan.
    START_CHARGE_THRESH_BAT0 = 65;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  environment.systemPackages = with pkgs; [ 
    git
    pciutils
    lm_sensors
  ];
}
