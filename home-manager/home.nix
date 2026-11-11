{ pkgs, ... }:

{
  imports = [
    ./modules/wezterm.nix
    ./modules/zsh.nix
    ./modules/fastfetch.nix
    ./modules/starship.nix
    ./modules/quickshell.nix
    ./modules/hyprland.nix
    ./modules/noctalia.nix
  ];

  home.username = "abyssus1719";
  home.homeDirectory = "/home/abyssus1719";

  home.stateVersion = "25.11";
}
