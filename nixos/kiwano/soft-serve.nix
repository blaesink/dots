{ pkgs, ...}:
let
  admin_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNrKHFuUXgCRARRT9I7aoTixvbmBSXLIKGDirxVGDtN kevin@jackfruit";
  script = pkgs.writeShellScriptBin "start-soft-serve" ''
    set -euo pipefail

    ${pkgs.docker}/bin/docker stop soft || true
    ${pkgs.docker}/bin/docker remove soft || true
    SOFT_SERVE_INITIAL_ADMIN_KEY="${admin_pub_key}" ${pkgs.docker}/bin/docker run --name soft \
    --network tunnel \
    --volume /var/soft-serve:/soft-serve \
    --publish 23231:23231 \
    --publish 23232:23232 \
    --publish 23233:23233 \
    --publish 9418:9418 \
    --restart unless-stopped \
    charmcli/soft-serve:v0.8.5
  '';
in {
  systemd.services.soft-serve = {
    path = [ pkgs.docker ];
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Soft Serve Git Server";
    after = [ "docker.service" ];

    serviceConfig = {
      ExecStart = "${script}/bin/start-soft-serve";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
