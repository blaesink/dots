CONFIG_FILE := ./home.nix

.PHONY: switch
switch:
	@nix run home-manager/release-23.11 -- -f ${CONFIG_FILE} switch

