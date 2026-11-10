{ pkgs, ... }:

{
  home.packages = [
    pkgs.quickshell
  ];

  xdg.configFile."quickshell" = {
    source = ../../quickshell;
    recursive = true;
  };
}
