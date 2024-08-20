# CPU: 14900KF
# GPU: NVIDIA RTX 4090
# RAM: 64GB
# Mobo: MSI Z790 WIFI

{ 
  config,
  lib,
  nixpkgs-latest,
  unstable,
  ...
}: 
let
  pkgs = nixpkgs-latest;
  packages = import (../packages.nix) { inherit pkgs unstable; };
  systemPackages = packages.environment.systemPackages;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "cuda-merged"
    "cudaPackages.cudatoolkit"
    "cudaPackages.cudnn"
  ];


  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jackfruit"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kevin = {
    isNormalUser = true;
    description  = "Kevin";
    extraGroups  = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU Kevin Blaesing <kevin.blaesing@gmail.com>"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJv5IcxMlG6lbMdrbypSMQ6lvK/60icQ4TS3ivtuaFUJ"
    ];
    # shell = pkgs.fish;
  };

  environment.systemPackages = systemPackages ++ [
    pkgs.cudaPackages.cudatoolkit
    pkgs.cudaPackages.cudnn
  ];

  # Gotta have my flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Don't change this!
  system.stateVersion = "24.05";


  # Set up nvidia drivers etc.
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = false;
    modesetting.enable     = true;
    open                   = false;
    package                = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}
