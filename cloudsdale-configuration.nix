{ config, pkgs, ... }:

{
  networking.hostName = "cloudsdale";
  networking.interfaces.eno1.useDHCP = true;

  # Authorize login using ssh key
  users.users.lyn.openssh.authorizedKeys.keyFiles = [
    ./ssh_keys/hpbox_id_rsa.pub
  ];
  services.openssh = {
    challengeResponseAuthentication = false;
    extraConfig = ''
      PasswordAuthentication no
      PermitRootLogin no
      UsePAM no
      '';
  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

