{ config, pkgs, ... }:

let
secrets = import ./secrets.nix;
in
{
  users.users.lyn.initialHashedPassword = "";

  # Setup networking
  networking.hostName = "raspi";
  networking.interfaces.eno1.useDHCP = true;
  networking.wireless.networks = secrets.networks;

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
}
