# NOTE: For a user called `my_user` to be authenticated on the samba server, you MUST add their password using:
# smbpasswd -a `my_user`
{config, ...}: 
let
  smbOptionStr = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  cifsMountOptions = {
    fsType = "cifs";
    options = ["${smbOptionStr},credentials=/etc/nixos/smb-secrets"]; 
  };
  commonShareArgs = {
    writeable = "yes";
    browseable = "yes";
    public = "yes";
    "create mask" = "0644";
    "directory mask" = "0755";
  };
in { 
  fileSystems = builtins.mapAttrs(_: dir: dir // cifsMountOptions) {
    "/mnt/share/junkyard" = { device = "//localhost/mnt/share/junkyard"; };
    "/mnt/share/kevin" = { device = "//localhost/mnt/share/kevin"; };
  };
  
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      # use sendfile = yes
      # max protocol = smb2
      # NOTE: localhost is the ipv6 localhost ::1
      # NOTE: the missing octet in the first one allows all local network machines.
      hosts allow = 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      map to guest = bad user
     '';
    shares = builtins.mapAttrs (_: share: commonShareArgs // share ) {
      junkyard = {
        path = "/mnt/share/junkyard";
        "force user" = "kiwano";
      };
      kevin = {
        path = "/mnt/share/kevin";
        public = "no";
        browseable = "no";
        "force user" = "kevin";
      };
    };
  };

  # Advertise to windows machines.
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
}
