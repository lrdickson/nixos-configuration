{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/925baef0-27b8-419b-bf55-9582cd51259e";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.firefox.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Security
  hardware.cpu.intel.updateMicrocode = true;

}
