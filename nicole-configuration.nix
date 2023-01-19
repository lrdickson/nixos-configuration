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
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
  networking.firewall.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  # minecraft startup
  systemd.services.dockerMinecraft = {
    description = "Minecraft running inside Docker Compose";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ]; # causes service to run at startup
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/etc/nixos/docker/minecraft";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      TimeoutStartSec = "0";
    };
  };

  # veloren startup
  systemd.services.dockerVeloren = {
    description = "Veloren running inside Docker Compose";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ]; # causes service to run at startup
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/etc/nixos/docker/veloren";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      TimeoutStartSec = "0";
    };
  };
}

