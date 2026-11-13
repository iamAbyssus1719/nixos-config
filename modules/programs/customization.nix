{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bibata-cursors
    papirus-icon-theme
    nwg-look
  ];
}
