{config, pkgs, ...}:
let
  script = pkgs.writeShellScriptBin "start-caddy" ''
    set -euo pipefail
    cf_token=$(cat ${config.age.secrets.cf_token.path})
    ${pkgs.docker}/bin/docker pull caddy@sha256:2c7c4a3b9534b34d598a02e7d2be61d3b3355fb77245aea43c27c6d93e09d55f
    ${pkgs.docker}/bin/docker run caddy@sha256:2c7c4a3b9534b34d598a02e7d2be61d3b3355fb77245aea43c27c6d93e09d55f
  '';
in {
  systemd.services.caddy = {
    path = [ pkgs.docker ];
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Caddy reverse proxy";
    after = [ "docker.service" ];
    serviceConfig = {
      ExecStart = "${script}/bin/start-caddy";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
