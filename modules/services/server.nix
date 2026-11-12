
{ pkgs, ... }:

let
  php = pkgs.php84.withExtensions ({ enabled, all }:
    enabled ++ (with all; [
      mysqli
      pdo_mysql
      zip
      gd
      curl
      mbstring
      intl
    ])
  );
in
{
  # Apache HTTP Server
  services.httpd = {
    enable = true;
    enablePHP = true;

    adminAddr = "admin@localhost";
    phpPackage = php;

    extraModules = [
      "rewrite"
    ];

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

  # PHP y Composer
  environment.systemPackages = [
    php
    php.packages.composer
    pkgs.nodejs
  ];

  # Puertos HTTP y HTTPS
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
