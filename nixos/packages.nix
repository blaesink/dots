{ pkgs, unstable, ... }: {
  environment.systemPackages = with pkgs; [
      bat # `cat` but better.
      btop
      delta # better `diff`
      erdtree # better `tree`
      unstable.eza
      fd
      fish
      fzy # fzf with "better default behavior".
      gcc13
      gh # Easier github login.
      git
      git-branchless
      gnumake
      helix
      procs # Better `ps`.
      ripgrep
      starship
      tealdeer
      ugrep
      zellij
      zlib
      zoxide
  ];
}
