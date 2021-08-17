{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gdb

    # General rust development
    gcc
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
}
