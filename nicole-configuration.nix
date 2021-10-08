{ config, pkgs, ... }:

{
  networking.hostName = "nicole";
  networking.interfaces.eno1.useDHCP = true;

  # Cron
  services.cron = {
    enable = true;
    cronFiles = [ ./cron/cron_mc_backup ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

