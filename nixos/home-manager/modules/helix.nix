{ config, lib, pkgs, ... }:
let
  cfg = config.custom.helix; 
  toml = pkgs.formats.toml {};
in
{
  options.custom.helix = {
    enable = lib.mkEnableOption "helix editor";
    package = lib.mkPackageOption pkgs "helix" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        theme = "darcula";
        editor =  {
          true-color = true;
          line-number = "relative";
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "error";
          indent-guides = {
            render = true;
            character = "╎";
            skip-levels = 0;
          };
        };
        keys.insert = {
          j.k = "normal_mode";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."${config.xdg.configHome}/helix/config.toml" = lib.mkIf (cfg.settings != {}) {
      source = toml.generate "helixConfig" cfg.settings;
    };
  };
}
