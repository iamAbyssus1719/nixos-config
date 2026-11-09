{ pkgs, ... }:

{
  imports = [
    ./modules/hyprland.nix
  ];

  home.username = "abyssus1719";
  home.homeDirectory = "/home/abyssus1719";

  home.stateVersion = "25.11";
}
