{ pkgs, unstable, ... }: {
  environment.systemPackages = with pkgs; [
      bat     # `cat` but better.
      btop
      delta   # better `diff`
      erdtree # better `tree`
      fd
      fish
      fishPlugins.hydro
      fzy     # fzf with "better default behavior".
      gcc13
      git
      gnumake
      unstable.jujutsu
      just
      procs   # Better `ps`.
      ripgrep
      repgrep # interactive search + replace powered by ripgrep
      starship
      tealdeer
      unstable.eza
      unstable.helix
      unstable.skim 
      watchexec
      zellij
      zlib
      zoxide
  ];
}
