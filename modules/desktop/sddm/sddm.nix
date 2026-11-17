
{ pkgs, ... }:

let
  source = pkgs.fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "main";
    hash = "sha256-0bYPQwI4+vkIGMHMBgawx1lpoV8XFpGhDyZFXM6T5b4=";
  };

  silentSDDM = pkgs.callPackage (source + "/nix/package.nix") {
    theme = "gruvbox";
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;

    theme = "silent";
    extraPackages = silentSDDM.propagatedBuildInputs;
  };

  environment.systemPackages = [
    silentSDDM
    silentSDDM.test
  ];

  # Avatar personalizado de SDDM
  systemd.tmpfiles.rules = [
    "f+ /var/lib/AccountsService/users/abyssus1719 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/abyssus1719\\n"
    "L+ /var/lib/AccountsService/icons/abyssus1719 - - - - ${./profile/YUKI.jpg}"
  ];
}
