{ config, pkgs, inputs, lib, ...}:
{
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+qtile";
    };

    windowManager.qtile = {
      enable = true;
    };

  };
}
