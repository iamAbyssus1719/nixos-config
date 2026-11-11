
{ pkgs, ... }:

{
  # Apache HTTP Server
  services.httpd = {
    enable = true;
    enablePHP = true;

    adminAddr = "admin@localhost";
    phpPackage = pkgs.php;

    virtualHosts.localhost = {
      documentRoot = "/var/www";

      extraConfig = ''
        <Directory "/var/www">
          AllowOverride All
          Require all granted
        </Directory>
      '';
    };
  };
  # MariaDB (compatible con MySQL)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # PHP y herramientas de desarrollo
  environment.systemPackages = with pkgs; [
    php
    php84Packages.composer
    phpExtensions.mysqli
    phpExtensions.pdo_mysql
    phpExtensions.zip
    phpExtensions.gd
    phpExtensions.curl
    phpExtensions.mbstring
    phpExtensions.xml
    phpExtensions.intl
    phpExtensions.openssl
  ];

  # Puertos HTTP y HTTPS
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
