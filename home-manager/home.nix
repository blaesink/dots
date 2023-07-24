{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lich";
  home.homeDirectory = "/home/lich";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

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

    ".config/fd/ignore".text = ''
    **/zig-cache/
    '';

    ".config/fish/config.fish".text = ''
      set fish_greeting
      set FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'

      fish_add_path ~/.local/bin

      abbr --erase z &>/dev/null
      abbr --erase zi &>/dev/null

      if type -q lvim
        set -gx EDITOR lvim
        alias v="lvim"
      end

      # Aliases
      alias sls="sl status"
      alias sld="sl diff"
      alias zi="__zoxide_zi"
      alias z="__zoxide_z"
      alias ff="fzf --bind 'enter:become($EDITOR {})'"

      zoxide init fish | source

      if type -q starship
        eval (starship init fish)
      end
    '';
    };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
