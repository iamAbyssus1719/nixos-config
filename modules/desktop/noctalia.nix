{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.noctalia
  ];
}
