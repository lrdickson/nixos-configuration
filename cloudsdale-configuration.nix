{ config, pkgs, ... }:

let
secrets = import ./secrets.nix;
in
{
  environment.systemPackages = with pkgs; [
    mailutils
  ];

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 2 * * *      root    /etc/nixos/cron/raid_notifications.sh"
    ];
  };

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

  services.ssmtp = {
    enable = true;
    authPassFile = "/run/keys/dicksonservergmail";
    authUser = "dicksonserver@gmail.com";
    hostName = "smtp.gmail.com:587";
    useSTARTTLS = true;
    useTLS = true;
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Setup nginx to handle https and automate certificate retrieval
  services.nginx = {
    enable = true;
    #sslProtocols = "TLSv1.1 TLSv1.2";
    virtualHosts."nextcloud.${secrets.domainName}" = {
      forceSSL = true;
      #addSSL = true;
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          client_max_body_size 800M;
	'';
        proxyPass = "http://127.0.0.1:8081";
      };
    };
    virtualHosts."collabora.${secrets.domainName}" = {
      forceSSL = true;
      enableACME = true;
      #locations."/" = {
      locations."^~ /loleaflet" = {
        proxyPass = "https://127.0.0.1:9980";
	extraConfig = "proxy_set_header Host $host;";
      };
      locations."^~ /hosting/discovery" = {
        proxyPass = "https://127.0.0.1:9980";
	extraConfig = "proxy_set_header Host $host;";
      };
      locations."^~ /hosting/capabilities" = {
        proxyPass = "https://127.0.0.1:9980";
	extraConfig = "proxy_set_header Host $host;";
      };
      locations."~ ^/lool/(.*)/ws$" = {
        proxyPass = "https://127.0.0.1:9980";
        proxyWebsockets = true;
	extraConfig = ''
	  proxy_set_header Host $host;
	  proxy_read_timeout 36000s;
	'';
      };
      locations."~ ^/lool" = {
        proxyPass = "https://127.0.0.1:9980";
	extraConfig = "proxy_set_header Host $host;";
      };
      locations."^~ /lool/adminws" = {
        proxyPass = "https://127.0.0.1:9980";
        proxyWebsockets = true;
	extraConfig = ''
	  proxy_set_header Host $host;
	  proxy_read_timeout 36000s;
	'';
      };
      locations."/" = {
        proxyPass = "https://127.0.0.1:9980";
        proxyWebsockets = true;
	extraConfig = ''
	  proxy_set_header Host $host;
	  proxy_read_timeout 36000s;
	'';
      };

    };
  };
  security.acme = {
    acceptTerms = true;
    certs = {
      "nextcloud.${secrets.domainName}".email = "lyndseyrd@gmail.com";
      "collabora.${secrets.domainName}".email = "lyndseyrd@gmail.com";
    };
  };

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

