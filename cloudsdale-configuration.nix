{ config, pkgs, ... }:
let
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
in
{
  networking.hostName = "cloudsdale";
  networking.interfaces.eno1.useDHCP = true;

  services.k3s.enable = true;

  environment.systemPackages = with pkgs; [
    kubernetes-helm
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

