{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  # Setup networking
  networking.hostName = "cloudsdale";
  networking.interfaces.eno1.useDHCP = true;

  # Authorize login using ssh key
  users.users.lyn.openssh.authorizedKeys.keyFiles = [
    ./ssh_keys/hpbox_id_rsa.pub
  ];
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # nextcloud startup
  systemd.services.dockerNextcloud = {
    description = "Nextcloud running inside Docker Compose";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ]; # causes service to run at startup
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/etc/nixos/docker/nextcloud";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      TimeoutStartSec = "0";
    };
  };
}

