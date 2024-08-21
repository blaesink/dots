# Open up some ports
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6379 # ray
      6443 # k3s
    ];
    allowedUDPPorts = [ 6379 ];
  };
}
