{ config, pkgs, inputs, lib, ...}:
{
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    windowManager.qtile = {
      enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
