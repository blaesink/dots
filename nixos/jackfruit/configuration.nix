# CPU: 14900KF
# GPU: NVIDIA RTX 4090
# RAM: 64GB
# MOBO: MSI Z790 WIFI

{ 
  config,
  nixpkgs-latest,
  unstable,
  ...
}: 
let
  pkgs = nixpkgs-latest;
in {
  nix.settings.trusted-users = ["root" "kevin"];
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../base.nix
    ../packages.nix
    ./hardware-configuration.nix
    ./kube.nix
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
    extraGroups  = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU Kevin Blaesing <kevin.blaesing@gmail.com>"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJv5IcxMlG6lbMdrbypSMQ6lvK/60icQ4TS3ivtuaFUJ"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = [
    pkgs.cudaPackages.cudatoolkit
    pkgs.cudaPackages.cudnn
    pkgs.mkl

    # Dev tools I just don't want to keep installing in a flake right now:
    unstable.coder
    pkgs.jq
    pkgs.pyright
    pkgs.ruff-lsp
    unstable.ghq     # Does a git clone of stuff into a predetermined place
    unstable.k9s
    unstable.nixd
    unstable.smartcat
    unstable.teleport
    unstable.television
    unstable.aider-chat
    unstable.cloudflared
    unstable.gemini-cli
  ];

  # Gotta have my flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "jackfruit";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.direnv.enable = true;
  programs.fish.enable   = true;
  programs.mtr.enable    = true;
  programs.nix-ld.enable = true;
  programs.mosh.enable   = true;

  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };


  # Don't change this!
  system.stateVersion = "24.05";

  # ==== Hardware Options ====

  # Set up nvidia drivers etc.
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = false;
    modesetting.enable     = true;
    open                   = false;
    package                = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6379 # ray
    ];
    allowedUDPPorts = [ 6379 ];
  };
  
}
