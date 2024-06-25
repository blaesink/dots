{ config, pkgs, ... }:
let
  script = pkgs.writeShellScriptBin "start-cf-tunnel" ''
    set -euo pipefail
    cf_token=$(cat ${config.age.secrets.cf_tun_tok.path})
    ${pkgs.docker}/bin/docker pull cloudflare/cloudflared:1548-628176a2d64c
    ${pkgs.docker}/bin/docker run cloudflare/cloudflared:1548-628176a2d64c tunnel \
    --no-autoupdate run \
    --token $cf_token 
  '';
in {
  systemd.services.cf-tunnel = {
    path = [ pkgs.docker ];
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Cloudflare docker tunnel";
    after = [ "docker.service" ];
    
    serviceConfig = {
      ExecStart = "${script}/bin/start-cf-tunnel";
      Restart = "on-failure";
      RestartSec = 10;
    };

  };
}
