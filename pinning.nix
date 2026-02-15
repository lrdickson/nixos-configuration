{ config, pkgs, ... }:
let sources = import ./npins;
in {
  # We need the flakes experimental feature to do the NIX_PATH thing cleanly
  # below. Given that this is literally the default config for flake-based
  # NixOS installations in the upcoming NixOS 24.05, future Nix/Lix releases
  # will not get away with breaking it.
  nix.settings = { experimental-features = "nix-command flakes"; };

  nixpkgs.flake.source = sources.nixpkgs;
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
}

