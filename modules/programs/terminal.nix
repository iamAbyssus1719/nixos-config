{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    wezterm
    fastfetch
    unimatrix
    tree
  ];
}
