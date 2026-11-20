
{ pkgs, ... }:

let
  source = pkgs.fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "main";
    hash = "sha256-0bYPQwI4+vkIGMHMBgawx1lpoV8XFpGhDyZFXM6T5b4=";
  };

  silentSDDM = pkgs.callPackage (source + "/nix/package.nix") {
    theme = "default";

    theme-overrides = {
      "LoginScreen" = {
        blur = 8;
      };

      "LoginScreen.MenuArea.Keyboard" = {
        display = false;
      };

      "LockScreen" = {
        blur = 8;
      };
    };
  };

in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "silent";

    extraPackages = silentSDDM.propagatedBuildInputs;

    settings = {
      General = {
        GreeterEnvironment =
          "QML2_IMPORT_PATH=${silentSDDM}/share/sddm/themes/silent/components/,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24";
      };

      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };

  environment.systemPackages = [
    silentSDDM
    silentSDDM.test
    pkgs.bibata-cursors
  ];

  systemd.tmpfiles.rules = [
    "f+ /var/lib/AccountsService/users/abyssus1719 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/abyssus1719\\n"
    "L+ /var/lib/AccountsService/icons/abyssus1719 - - - - ${./profile/YUKI.jpg}"
  ];
}
