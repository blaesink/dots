{ home-manager, ... }:  {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kevin = ../home-manager/macbook.nix;
  };
}

