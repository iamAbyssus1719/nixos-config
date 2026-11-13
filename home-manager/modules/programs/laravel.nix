{ pkgs, ... }:

{
  home.packages = with pkgs; [
    laravel
  ];
}
