{
  lib,
  config,
  pkgs,
  unstable,
  userVars ? {},
  ...
}: let
  cfg = config.custom.jj;
in {
  options.custom.jj = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Jujutsu (jj) module";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "blaesink";
      description = "Jujutsu user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "dev@blaesing.xyz";
      description = "Jujutsu user email";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with unstable; [ jjui ];
      description = "Additional Jujutsu-related packages to install";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ui = {
          pager = ["delta" "--diff-so-fancy"];
          diff-formatter = ":git";
          default-command = ["log" "--no-pager"];
          merge-editor = ":builtin";
          conflict-marker-style = "diff";
          graph.style = "curved";
        };
        git = {
          # remove the need for `--allow-new` when pushing new bookmarks
          auto-local-bookmark = true;
          push-new-bookmarks = true;
        };
        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
          # The following command is incorrect, TODO
          # "default()" = "coalesce(trunk(),root())::present(@) | ancestors(visible_heads() & recent(), 2)";
          "recent()" = "committer_date(after:'1 month ago')";
          trunk = "main@origin";
        };
        template-aliases = {
          "format_short_change_id(id)" = "id.shortest()";
        };
        aliases = {
          c = ["commit"];
          ci = ["commit" "--interactive"];
          e = ["edit"];
          i = ["git" "init" "--colocate"];
          tug = ["bookmark" "move" "--from" "closest_bookmark(@-)" "--to" "@-"];
          log-recent = ["log" "-r" "default() & recent()"];
          nb = ["bookmark" "create" "-r" "@-"]; # new bookmark
          upmain = ["bookmark" "set" "main"];
          squash-desc = ["squash" "::@" "-d" "@"];
          rebase-main = ["rebase" "-d" "main"];
          amend = ["describe" "-m"];
          pushall = ["git" "push" "--all"];
          push = ["git" "push" "--allow-new"];
          pull = ["git" "fetch"];
          dmain = ["diff" "-r" "main"];
          l = ["log" "-T" "builtin_log_compact" "--no-pager"];
          lf = ["log" "-r" "all()"];
          r = ["rebase"];
          s = ["show" "--no-pager"];
          sq = ["squash"];
          sqi = ["squash" "--interactive"];
        };
        revsets = {
          # log = "main@origin";
          # log = "master@origin";
        };
      };
      description = "Jujutsu configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    programs.jujutsu = {
      package = unstable.jujutsu;
      enable = true;
      settings = lib.mergeAttrs cfg.settings {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
      };
    };
  };
}
