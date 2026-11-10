
{ pkgs, ... }:

let
  catppuccin = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = "JetBrains Mono";
    fontSize = "11";
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;

    theme = "catppuccin-mocha-mauve";

    extraPackages = [
      catppuccin
    ];
  };

  environment.systemPackages = [
    catppuccin
  ];
}
