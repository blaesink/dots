{ pkgs, unstable, packagesType ? "", ... }:
let
  fishPlugins = with pkgs.fishPlugins; [
    hydro
    sponge
  ];
  unstablePackages = with unstable; [
      jujutsu
      eza
      helix
      skim 
  ];
  stablePackages = with pkgs; [
      bat     # `cat` but better.
      btop
      delta   # better `diff`
      erdtree # better `tree`
      fd
      fish
      fzy     # fzf with "better default behavior".
      gcc13
      git
      gnumake
      just
      procs   # Better `ps`.
      ripgrep
      repgrep # interactive search + replace powered by ripgrep
      starship
      tealdeer
      watchexec
      zellij
      zlib
      zoxide
  ];
  allPackages = unstablePackages ++ stablePackages;
in {
  environment.systemPackages = {
    withFish = allPackages ++ fishPlugins;
  }."${packagesType}" or allPackages;
}
