{ config, pkgs, stdenv, fetchFromGitHub, fetchgit, ... }:
let
  myvlang= pkgs.callPackage ./vlang.nix {};
in
{
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

  environment.systemPackages = with pkgs; [
    # Gui
    airshipper
    bitwarden
    discord
    #filezilla
    gparted
    libreoffice
    minecraft
    qbittorrent
    sakura
    vlc
    wineWowPackages.stable
    mono
    pinta # paint application
    zettlr # markdown editor
    zoom-us

    # Terminal utilities
    bitwarden-cli
    file # Provide information about a file
    gnupg
    #home-manager
    html-tidy # Formatter for HTML
    neovim-remote
    nerdfonts # fonts for terminal
    #nixos-generators
    nnn # terminal file manager
    pandoc # universal document converter
    poppler_utils
    python
    python39Packages.sqlparse # For vim SQL formatting
    ripgrep
    ripgrep-all
    sqlint
    texlive.combined.scheme-small # latex support
    universal-ctags
    unzip
    usbutils
    w3m # terminal web browser
    zip

    # programming
    #arduino
    #arduino-cli
    gcc
    gdb
    go
    nim
    nimlsp # nim language server
    nodejs
    myvlang

    # rust
    #cargo
    #rust-analyzer
    #rustc
    #rustup
    #wasm-pack

    # flutter
    #clang
    #cmake
    #dart
    #flutter
    #gtk3
    #ninja
    #pkgconfig
    #virtualgl # for viewing GL over ssh

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

  # Testing go libp2p chat
  networking.firewall.allowedTCPPorts = [ 3001 ];

  # virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "lyn" ];

  # Enable binfmt emulation of aarch64-linux.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # ubuntu container
  #systemd.services.ubuntu = {
    #description = "Ubuntu container running inside Docker Compose";
    #after = [ "docker.service" ];
    #requires = [ "docker.service" ];
    #wantedBy = [ "multi-user.target" ]; # causes service to run at startup
    #serviceConfig = {
      #Type = "oneshot";
      #RemainAfterExit = "yes";
      #WorkingDirectory = "/etc/nixos/docker/ubuntu";
      #ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down";
      #ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      #ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      #TimeoutStartSec = "0";
    #};
  #};
}
