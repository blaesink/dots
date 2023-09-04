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
    kitty
    neovim
    ripgrep
    sapling
    starship
    wezterm
    zlib
    zoxide
  ];

  programs.fish.enable = true;
}
