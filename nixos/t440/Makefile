CONFIG_FILE := ./configuration.nix

.PHONY: test
test:
	@sudo nixos-rebuild test -I nixos-config=${CONFIG_FILE}

.PHONY: switch
switch:
	@sudo nixos-rebuild switch -I nixos-config=${CONFIG_FILE}

