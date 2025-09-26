{ config, pkgs, lib, ... }:
let
  sitename = "bllry.com";
  docroot = "/var/www/bllry";
  domainname = "bllry.com";
in {
  services.nginx = {
    enable = true;
    
    virtualHosts = {
      "${domainname}" = {
        # Document root for your static files
        root = "${docroot}";
        
        # SSL setup
        forceSSL = true;
        enableACME = true;
        
        # Basic static file serving
        locations."/" = {
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };
        
        # Cache static assets
        locations."~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$" = {
          extraConfig = ''
            expires 1y;
            add_header Cache-Control "public, immutable";
            log_not_found off;
          '';
        };
      };
      
      # Redirect 'www' to 'non-www'
      "www.${domainname}" = {
        forceSSL = true;
        enableACME = true;
        globalRedirect = "${domainname}";
      };
    };
  };

  # ACME configuration for Let's Encrypt
  security.acme = {
    acceptTerms = true;
    defaults.email = "bllryy@proton.me";
  };


}
