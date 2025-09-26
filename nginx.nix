{ config, pkgs, lib, ... }: {
  # Enable nginx and adjust firewall rules.
  services.nginx.enable = true;
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
  # Add some hosting/Drupal specific packages.
  environment.systemPackages = with pkgs; [
    #php
    #phpPackages.composer
    # drush # Since 24.05 not available anymore and must be used with composer instead.
  ];
  
  # Set some SSL certificate renewal settings.
  security.acme = {
    acceptTerms = true;
    defaults.email = "bllryy@proton.me";
    defaults.group = "nginx";
  };
  # /var/lib/acme/.challenges must be writable by the ACME user
  # and readable by the Nginx user. The easiest way to achieve
  # this is to add the Nginx user to the ACME group.
  users.users.nginx.extraGroups = [ "acme" ];
  environment.variables = {
    PLATFORM = "production";
  };
}
