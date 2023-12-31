{ config, pkgs, inputs, lib, ...}:
{
environment.systemPackages = with pkgs; [
    bat # `cat` but better.
    btop
    fd
    fish
    fzy # fzf with "better default behavior".
    gcc13
    gh # Easier github login.
    git
    gnumake
    helix
    ripgrep
    starship
    tealdeer
    zellij
    zlib
    zoxide
];

  programs.fish.enable = true;
}
