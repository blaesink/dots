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
      gh      # Easier github login.
      git
      git-branchless
      gnumake
      just
      procs   # Better `ps`.
      ripgrep
      starship
      tealdeer
      ugrep
      unstable.eza
      unstable.helix
      zellij
      zlib
      zoxide
  ];
}
