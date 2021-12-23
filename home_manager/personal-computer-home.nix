{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gui
    discord
    etcher
    filezilla
    gparted
    libreoffice
    qbittorrent
    reaper
    vlc
    zoom-us

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
