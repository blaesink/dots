{ config, lib, pkgs, ... }:
let
  toKDL = lib.hm.generators.toKDL {};
  cfg = config.custom.zellij;
in {
  options.custom.zellij = {
    package = lib.mkPackageOption pkgs "zellij" { nullable = true; };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.xdg.configHome}/zellij/config.kdl";
      defaultText = lib.literalExpression "\${config.xdg.configHome}/zellij/config.kdl";
    };

    zmate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable zmate";
      };
      package = lib.mkPackageOption pkgs "zmate" { nullable = true; };
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        keybinds = {
          unbind = "Ctrl o";
          normal = {
            "bind \"Ctrl k\"" = { SwitchToMode = "session"; };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        []
        ++ lib.optional (cfg.package != null) cfg.package
        ++ lib.optional cfg.zmate.enable cfg.zmate.package
      ;

      file.${cfg.configPath} = lib.mkIf ( cfg.settings != {} ) {
        text = toKDL cfg.settings;
      };
    };
  };
}
