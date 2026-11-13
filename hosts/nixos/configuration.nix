{ config, pkgs, ... }:

{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # System
    ../../modules/system/audio.nix
    ../../modules/system/bluetooth.nix

    # Desktop
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/noctalia.nix
    ../../modules/desktop/sddm.nix

    # Services
    ../../modules/services/server.nix

    # Programs
    ../../modules/programs/development.nix
    ../../modules/programs/terminal.nix
    ../../modules/programs/aplications.nix
    ../../modules/programs/customization.nix
    ../../modules/programs/utilities.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "America/Merida";
  i18n.defaultLocale = "es_MX.UTF-8";

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # USB
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # XDG
  xdg.autostart.enable = true;

  # User
  users.users.abyssus1719 = {
    isNormalUser = true;
    description = "Abyssus1719";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.packages = with pkgs; [
    inconsolata
  ];

  # State version
  system.stateVersion = "26.05";
}
