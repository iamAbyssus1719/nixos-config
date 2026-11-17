{ pkgs, ... }:

{
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
