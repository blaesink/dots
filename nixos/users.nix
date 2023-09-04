{ config, pkgs, inputs, lib, ...}:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lich = {
    isNormalUser = true;
    description = "Kevin";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

# Enable automatic login for the user.
  services.getty.autologinUser = "lich";
}
