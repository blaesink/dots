# CPU: 14900KF
# GPU: NVIDIA RTX 4090
# RAM: 64GB
# MOBO: MSI Z790 WIFI

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
  nix.settings.trusted-users = ["root" "kevin"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "cuda_cuobjdump"
    "cuda_gdb"
    "cuda_nvcc"
    "cuda-merged"
    "cudaPackages.cudatoolkit"
    "cudaPackages.cudnn"
    "mkl"
    "nvidia-persistenced"
    "nvidia-settings"
    "nvidia-x11"
  ];


  imports = [
    ../base.nix
    ./hardware-configuration.nix
    ./kube.nix
    # ./ports.nix
  ];

  # Configure keymap in X11
  services = {
    xserver.xkb = {
      layout  = "us";
      variant = "";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kevin = {
    isNormalUser = true;
    description  = "Kevin";
    extraGroups  = [ "networkmanager" "wheel" "docker" "podman" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU Kevin Blaesing <kevin.blaesing@gmail.com>"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJv5IcxMlG6lbMdrbypSMQ6lvK/60icQ4TS3ivtuaFUJ"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = systemPackages ++ [
    pkgs.cudaPackages.cudatoolkit
    pkgs.cudaPackages.cudnn
    pkgs.kubernetes-helm # "helm" in the pkgs repo is an audio synthesizer
    pkgs.mkl

    pkgs.docker-compose

    # Using docker here is a workaround.
    # It will install nvidia-container-runtime and that will cause it to be accessible via /run/current-system/sw/bin/nvidia-container-runtime.
    # Currently its not directly accessible in nixpkgs.

    # pkgs.docker

    # Dev tools I just don't want to keep installing in a flake right now:
    pkgs.pyright
    pkgs.ruff-lsp
    unstable.smartcat
  ];

  # Gotta have my flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "jackfruit";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.direnv.enable = true;
  programs.fish.enable = true;
  programs.mtr.enable = true;
  programs.nix-ld.enable = true;
  programs.mosh.enable = true;

  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };


  # Don't change this!
  system.stateVersion = "24.05";

  # ==== Hardware Options ====

  # Set up nvidia drivers etc.
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = false;
    modesetting.enable     = true;
    open                   = false;
    package                = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # For GPU passthrough to containers.
  hardware.nvidia-container-toolkit.enable = true;

  # ==== Virtualization ====

  # Enable podman. Common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.docker= {
    enable = true;
    enableNvidia = true;
  };


  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6379 # ray
      6443 # k3s
    ];
    allowedUDPPorts = [ 6379 ];
  };
  
}
