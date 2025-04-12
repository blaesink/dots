# The Config Monolithic Monorepo

This repository holds everything about my system configs.

The most salient ones are in `home-manager/` and `nixos/`.

## `nixos/` directory
The `nixos/` folder has every configuration for every nixos machine I have (which is all of them).
Every machine is built from the same `flake.nix` in this directory, which has various nixos channels.
