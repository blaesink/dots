{ config, pkgs, inputs, lib, ...}:
{
# Backlight stuff
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
    { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  services.xserver.xkbOptions = "ctrl:swapcaps";
}
