{ pkgs, unstable, packagesType ? "", ... }:
let
  fishPlugins = with pkgs.fishPlugins; [ hydro sponge ];
  unstablePackages = with unstable; [ eza helix skim moreutils jujutsu jjui ];
  stablePackages = with pkgs; [
    bat # `cat` but better.
    btop
    delta # better `diff`
    entr
    erdtree # better `tree`
    fd
    fish
    git
    gnumake
    home-manager
    just
    procs # Better `ps`.
    ripgrep
    repgrep # interactive search + replace powered by ripgrep
    tealdeer
    watchexec
    zellij
    zlib
    zoxide
  ];
  mkPackages = (type:
    let
      base = stablePackages ++ unstablePackages;
      withFish = base ++ fishPlugins;
    in { inherit base withFish; }.type or base);

in { environment.systemPackages = mkPackages packagesType; }
