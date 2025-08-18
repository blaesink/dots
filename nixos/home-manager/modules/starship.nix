{ config, lib, ... }:
let
  cfg = config.custom.starship;
in {
  options.custom.starship = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Starship";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;

        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
        };
        package.disabled = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = lib.mergeAttrs cfg.settings {};
      enableFishIntegration = true;
    };
  };
}
