{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    brightnessctl
    unzip
    jq
    usbutils
    grim
    slurp
  ];
}
