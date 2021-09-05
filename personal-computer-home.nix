{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gui
    libreoffice

    # Terminal utilities
    usbutils
    nerdfonts # fonts for terminal

    # programming
    arduino
    arduino-cli
    gcc
    gdb

    # General rust development
    rust-analyzer

    # Rust embedded development
    cargo-binutils
    cargo-generate
    openocd
    qemu_full

    # Rust wasm
    wasm-pack
  ];

  # Other config files
  home.file.".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;

  # Add icons to nnn
  nixpkgs.overlays = [
    ( self: super: { nnn = super.nnn.override { withNerdIcons = true; };})
  ];
}
