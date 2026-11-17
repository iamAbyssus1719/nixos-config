{ pkgs, ... }:

{

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

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
    distrobox
  ];
}
