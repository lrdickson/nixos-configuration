{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gui
    etcher
    discord
    libreoffice
    qbittorrent

    # Terminal utilities
    gnupg
    nerdfonts # fonts for terminal
    OVMF # uefi firmware for qemu
    usbutils
    qemu_full

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

    # Rust wasm
    wasm-pack
  ];

  # Other config files
  home.file.".gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
}