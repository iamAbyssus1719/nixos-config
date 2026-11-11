{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Home Manager
    <home-manager/nixos>

    # System
    ./modules/system/audio.nix
    ./modules/system/bluetooth.nix

    # Desktop
    ./modules/desktop/hyprland.nix
    ./modules/desktop/noctalia.nix
    ./modules/desktop/sddm.nix

    # Programs
    ./modules/programs/vscode.nix

    # Services
    ./modules/services/server.nix
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
    layout = "us";
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
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";
    users.abyssus1719 = import ./home-manager/home.nix;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    kitty
    wezterm
    fastfetch
    firefox
    nautilus
    pavucontrol
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    bibata-cursors
    tree
    papirus-icon-theme
    nwg-look
    brightnessctl
    unzip
    jq
    usbutils
  ];

  # Fonts
  fonts.packages = with pkgs; [
    inconsolata
  ];

  # State version
  system.stateVersion = "26.05";
}
