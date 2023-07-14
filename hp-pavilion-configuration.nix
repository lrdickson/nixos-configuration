{ config, pkgs, stdenv, fetchFromGitHub, fetchgit, ... }:
let
  myvlang= pkgs.callPackage ./vlang.nix {};
in
{
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  boot.initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/303d4899-b2dd-4bb6-9950-4c834f10ba9a";
        preLVM = true;
      };
  };

  boot = {
    # Use newer kernel for wifi support
    # kernelPackages = pkgs.linuxPackages_testing;
    # The rtw88_8821ce module kind of stinks
    blacklistedKernelModules = [
      #"rtw88_8821ce"
    ];
    extraModulePackages = [
      #pkgs.linuxPackages_latest.rtl8821ce
      #pkgs.linuxPackages_zen.rtl8821ce
    ];
    #kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "hpbox";

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # Gui
    #airshipper
    #bitwarden
    #discord
    #filezilla
    gnome.gnome-software # software manager - here for flatpak
    gparted
    #libreoffice
    #minecraft
    #qbittorrent
    #sakura
    #vlc
    #wineWowPackages.stable
    #mono
    nextcloud-client # The flatpak version can't open browsers
    #pinta # paint application
    #zettlr # markdown editor
    #zoom-us

    # Terminal utilities
    acpi # battery monitoring cli
    bitwarden-cli
    cargo
    file # Provide information about a file
    gnupg
    #home-manager
    #html-tidy # Formatter for HTML
    #neovim-remote
    #nerdfonts # fonts for terminal
    #nixos-generators
    nnn # terminal file manager
    pandoc # universal document converter
    poppler_utils
    #python
    #python39Packages.sqlparse # For vim SQL formatting
    ripgrep
    ripgrep-all
    #sqlint
    texlive.combined.scheme-small # latex support
    universal-ctags
    unzip
    usbutils
    w3m # terminal web browser
    zip

    # programming
    #arduino
    #arduino-cli
    cloc
    #gcc
    #gdb
    go
    gopls
    nodejs # needed for Coc
    #myvlang
    zig
    zls # zig language server

    # rust
    #cargo
    #rust-analyzer
    #rustc
    #rustup
    #wasm-pack

  ];

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
    };
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      #defaultNetwork.dnsname.enable = true;
      # For Nixos version > 22.11
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  # virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "lyn" ];

  # Enable binfmt emulation of aarch64-linux.

}
