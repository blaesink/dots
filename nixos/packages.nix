{ config, pkgs, inputs, lib, ...}:
{
environment.systemPackages = with pkgs; [
    bat # Bat but better.
    brave
    btop
    fd
    fish
    fzf
    fzy # fzf with "better default behavior"
    gcc13
    gh # For sapling
    git
    gnumake
    helix
    kitty
    neovim
    ripgrep
    sapling
    starship
    tealdeer
    waybar
    wezterm
    wofi
    zellij
    zlib
    zoxide
];

  programs.fish.enable = true;
}
