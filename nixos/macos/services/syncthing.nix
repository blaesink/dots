{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.syncthing;
  settingsFormat = pkgs.formats.json { };
in {
  options.services.syncthing = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable syncthing";
    };
    pkg = mkOption {
      type = package;
      default = pkgs.syncthing-macos;
      description = "Default package to use";
    };
    settings = mkOption {
      type = submodule {
        devices = mkOption {
          type = attrsOf (
            submodule (
              { name, ... }:
              {
                freeformType = settingsFormat.type;
                options = {
                  id = mkOption {
                    type = str;
                    description = "ID of device";
                  };
                  name = mkOption {
                    type = str;
                    default = name;
                    description = "Name of device";
                  };
                };
              }
            )
          );
          default = {};
          description = ''
            The devices which Syncthing should communicate with.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.pkg ];
    launchd.agents.syncthing = {
      serviceConfig = {
        Label = "com.syncthing.default";
        ProgramArguments = [ "${cfg.pkg}/bin/syncthing" ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
