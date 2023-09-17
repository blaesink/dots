{ config, pkgs, inputs, lib, ...}:
{
environment.systemPackages = with pkgs; [
    brave
    btop
    fd
    fish
    fzf
    fzy # fzf with "better default behavior"
    gcc13
    gh
    git
    gnumake
    helix
    kitty
    neovim
    ripgrep
    sapling
    starship
    waybar
    wezterm
    wofi
    zlib
    zoxide
];

  programs.fish.enable = true;
}
