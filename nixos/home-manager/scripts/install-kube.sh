#!/usr/bin/env bash
set -euo pipefail

CONFIGDIR=dotfiles/k3s
# Need to say where the kubeconfig is.
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Updating rancher symlink.."
ln -sf $CONFIGDIR/config.toml /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl

echo "Applying nvidia runtime class to cluster.."
kubectl apply -f $CONFIGDIR/runtime_class.yaml &> /dev/null

helm repo add nvdp https://nvidia.github.io/k8s-device-plugin &> /dev/null
helm repo update &> /dev/null

helm upgrade -i nvdp nvdp/nvidia-device-plugin \
  --namespace nvidia-device-plugin \
  --create-namespace \
  --version 0.16.1 \
  --set-file config.map.config=dotfiles/k3s/helm-config.yaml
