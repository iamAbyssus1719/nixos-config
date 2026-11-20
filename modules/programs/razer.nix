{ config, pkgs, ... }:

{
  users.users.abyssus1719.extraGroups = [ "openrazer" ];

  environment.systemPackages = with pkgs; [
    polychromatic
    openrazer-daemon
  ];
}
