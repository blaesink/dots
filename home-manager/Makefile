CONFIG_FILE := ./${USER}.nix

.PHONY: switch
switch:
	@nix run home-manager/release-24.05 -- -f ${CONFIG_FILE} switch

