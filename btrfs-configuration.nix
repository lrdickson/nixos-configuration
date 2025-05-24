{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  # enable btrfs support
  boot.supportedFilesystems = [ "btrfs" ];
}
