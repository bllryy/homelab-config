# https://wiki.nixos.org/wiki/Forgejo

{ config, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    
    database = {
      type = "sqlite3";  # or "postgres"
      # path = "/var/lib/forgejo/data/forgejo.db";  # default for sqlite3
    };
    
    # Basic settings
    settings = {
      server = {
        DOMAIN = "git.bllry.com";  # Change to your domain
        ROOT_URL = "https://git.bllry.com";  # Change to your URL
        HTTP_PORT = 3000;
        # HTTP_ADDR = "127.0.0.1";  # Listen only on localhost if using reverse proxy
      };
      
      service = {
        DISABLE_REGISTRATION = true;  # Set to true to disable public registration
      };
      
      # Optional: Email settings for notifications
      mailer = {
      	ENABLED = true;
      	FROM = "forgejo@bllry.com";
      	SMTP_ADDR = "smtp.bllry.com";
      	SMTP_PORT = 587;
      # };
    };
  };

  # Open firewall port (if not using reverse proxy)
  networking.firewall.allowedTCPPorts = [ 3000 ];
  
  # Optional: Nginx reverse proxy configuration
  services.nginx = {
    enable = true;
    virtualHosts."git.yourdomain.com" = {
      forceSSL = true;
      enableACME = true;  # Automatic Let's Encrypt SSL
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "bllryy@proton.me";
  };
}
