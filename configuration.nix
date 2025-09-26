{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nginx.nix
      ./nginx.mysite.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-server-1"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Amercia/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

   users.users.lily = {
     isNormalUser = true;
     extraGroups = [ "wheel" "acme" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       vim
     ];
   };


   environment.systemPackages = with pkgs; [
     vim 
     wget
     git
     curl
     neofetch
     openssl
     fastfetch
   ];
  
  services.openssh = {
	enable = true; 
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  system.stateVersion = "25.05"; 

}

