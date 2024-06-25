# Kiwano Configuration.
# === Specs ===
# Machine: Lenovo P53
# Memory:  64GB
# CPU:     Intel 8950HX
# GPU:     NVIDIA Quadro T1000 Mobile
# =============

{ config, lib, pkgs, unstable, modulesPath, agenix, ... }: 
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
    ./cf_tunnel.nix
  ];
  system.stateVersion = "23.11"; # Don't change this!
  networking.hostName = "kiwano";

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 7844 ];
    allowedUDPPorts = [ 7844 ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  # Don't need here. Just set manually.
  networking.networkmanager.enable = false;
  networking.useDHCP = true;
  networking.interfaces.enp0s31f6.ipv4.addresses = [{
    address = "192.168.1.32";
    prefixLength = 24;
  }];

  age = {
    secrets.cf_tun_tok.file = ../secrets/cloudflare_tunnel_token.age;
    identityPaths = [ "/root/.ssh/localKey" ];
  };

  virtualisation.docker.enable = true;

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

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
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
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  services.tlp.settings = {
    # Keep battery from being fully charged to prolong its lifespan.
    START_CHARGE_THRESH_BAT0 = 65;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  environment.systemPackages = with pkgs; [ 
    git
    pciutils
    lm_sensors
  ] ++ [ agenix.packages.x86_64-linux.default ];
}
