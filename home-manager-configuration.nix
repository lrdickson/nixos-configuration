{ config, pkgs, ... }:

{
  imports =
    [
      # Add home manager options
      <home-manager/nixos>
    ];

  home-manager.users.lyn = {
    imports = [
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    # Manager Per User Configuration
    home-manager
  ];
}
