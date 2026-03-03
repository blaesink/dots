{ config, pkgs, ... }:
let
  user = config.system.primaryUser;
  home = "/Users/${user}";
in
{
  system.primaryUser = "kevin";

  launchd.user.agents."colima.default" = {
    command = "${pkgs.colima}/bin/colima start --foreground";

    # path = [ pkgs.colima pkgs.docker ];

    environment = {
      HOME = home;
      USER = user;
      LOGNAME = user;
      PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    };

    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;

      # do not restart-loop colima while debugging this
      KeepAlive = false;

      WorkingDirectory = home;
      StandardOutPath = "${home}/Library/Logs/colima-launchd.stdout.log";
      StandardErrorPath = "${home}/Library/Logs/colima-launchd.stderr.log";
    };
  };
}
