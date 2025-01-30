{ pkgs, ... }: {
  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = (toString [
      "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
    ]);
  };

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
    containers.cdi.dynamic.nvidia.enable = true;

    # For the nvidia-container-runtime.
    docker = {
      enable       = true;
      enableNvidia = true;
    };

    # k3s-related; more info at https://github.com/NixOS/nixpkgs/blob/34ed0c9cc1bb45c7cbfda050236282e0023d25fb/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md
    containerd = {
      enable = true;

      settings =
        let
          runtime_type = "io.containerd.runc.v2";
          fullCNIPlugins = pkgs.buildEnv {
            name = "full-cni";
            paths = with pkgs; [
              cni-plugins
              cni-plugin-flannel
            ];
          };
        in
        {
          plugins."io.containerd.grpc.v1.cri" = {
            enable_cdi    = true;
            cdi_spec_dirs = [ "/var/run/cdi" ];
            cni = {
              bin_dir  = "${fullCNIPlugins}/bin";
              conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
            };
            containerd = {
              # default_runtime_name = "nvidia";
              # runtimes.runc.runtime_type = runtime_type;
              runtimes.runc = { inherit runtime_type; };
              runtimes.nvidia = {
                inherit runtime_type;
                
                privileged_without_host_devices = false;
                options = {
                  BinaryName    = "/run/current-system/sw/bin/nvidia-container-runtime";
                  SystemdCgroup = true;
                };
              };
              runtimes."nvidia-cdi" = {
                inherit runtime_type;
                options = {
                  BinaryName    = "/run/current-system/sw/bin/nvidia-container-runtime.cdi";
                  SystemdCgroup = true;
                };
              };
            };
          };
        };
    };
  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm

    # Using docker here is a workaround.
    # It will install nvidia-container-runtime and that will cause it to be accessible via /run/current-system/sw/bin/nvidia-container-runtime.
    # Currently its not directly accessible in nixpkgs.
    docker
    runc
    libnvidia-container
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];

}
