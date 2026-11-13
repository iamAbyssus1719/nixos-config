{ pkgs, ... }:

{
  imports = [

    # desktop
    ./modules/desktop/hyprland.nix
    ./modules/desktop/noctalia.nix
    ./modules/desktop/quickshell.nix
    ./modules/desktop/google-fonts.nix

    # programs
    ./modules/programs/fastfetch.nix
    ./modules/programs/vscode.nix
    ./modules/programs/vscode-settings.nix
    ./modules/programs/laravel.nix
    ./modules/programs/esp32.nix

    # shell
    ./modules/shell/starship.nix
    ./modules/shell/zsh.nix

    # terminal
    ./modules/terminal/wezterm.nix

  ];

  home.username = "abyssus1719";
  home.homeDirectory = "/home/abyssus1719";

  home.stateVersion = "25.11";
}
