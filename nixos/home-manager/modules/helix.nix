{ config, lib, pkgs, ... }:
let
  cfg = config.custom.helix;
  toml = pkgs.formats.toml { };
  default-theme = "darcula";
in {
  options.custom.helix = {
    enable = lib.mkEnableOption "helix editor";
    package = lib.mkPackageOption pkgs "helix" { };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        theme = default-theme;
        editor = {
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
        keys = {
          insert = { j.k = "normal_mode"; };
          normal = {
            ret = "goto_word";
            b = {
              r = ":reload";
              R = ":reload-all";
              p = ":buffer-previous";
              n = ":buffer-next";
              q = ":buffer-close";
              w = ":write-buffer-close";
              s = ":write";
            };
            space.t = {
              "0" = ":theme ${cfg.settings.theme or default-theme}";
              "1" = ":theme rose_pine_dawn";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."${config.xdg.configHome}/helix/config.toml" =
      lib.mkIf (cfg.settings != { }) {
        source = toml.generate "helixConfig" cfg.settings;
      };
  };
}
