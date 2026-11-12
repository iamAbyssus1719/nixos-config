
{ pkgs, ... }:

let
  noctaliaSettings = import ../../configs/noctalia/settings.nix;
in
{
  xdg.configFile."noctalia/config.toml".source =
    (pkgs.formats.toml {}).generate
      "noctalia-config.toml"
      noctaliaSettings;

  xdg.configFile."noctalia/assets" = {
    source = ../../configs/noctalia/assets;
    recursive = true;
  };
}
