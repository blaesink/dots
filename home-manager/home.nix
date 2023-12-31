{ config, pkgs, ... }:

{
  home.username = "lich";
  home.homeDirectory = "/home/lich/";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/lvim/config.lua".source = dotfiles/lvim/config.lua;

    ".config/fd/ignore".text = ''
    **/zig-cache/
    '';

    ".config/fish/config.fish".source = dotfiles/fish/config.fish;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    ".config/qtile/config.py".source = dotfiles/qtile/config.py;
    ".config/zellij/config.kdl".source = dotfiles/zellij/config.kdl;
    "/.config/hypr/hyprland.conf".source = dotfiles/hyprland/hyprland.conf;
    };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
