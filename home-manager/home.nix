{ pkgs, ... }:

{
  imports = [
    ./modules/wezterm.nix
    ./modules/zsh.nix
    ./modules/fastfetch.nix
    ./modules/starship.nix
  ];

  home.username = "abyssus1719";
  home.homeDirectory = "/home/abyssus1719";

  home.stateVersion = "25.11";
}
