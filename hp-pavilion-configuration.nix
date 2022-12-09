{ config, pkgs, ... }:

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
    discord
    filezilla
    gparted
    libreoffice
    minecraft
    qbittorrent
    reaper
    sakura
    vlc
    wineWowPackages.stable
    mono
    pinta # paint application
    zettlr
    zoom-us

    # Terminal utilities
    file # Provide information about a file
    gnupg
    home-manager
    html-tidy # Formatter for HTML
    neovim-remote
    nerdfonts # fonts for terminal
    nnn # terminal file manager
    pandoc # universal document converter
    poppler_utils
    python
    python39Packages.sqlparse # For vim SQL formatting
    ripgrep
    ripgrep-all
    sqlint
    universal-ctags
    unzip
    usbutils
    w3m # terminal web browser
    zip

    # programming
    arduino
    arduino-cli
    gcc
    gdb
    nim
    nimlsp # nim language server
    nodejs

    # rust
    cargo
    rust-analyzer
    rustc
    rustup
    wasm-pack

    # flutter
    clang
    cmake
    dart
    flutter
    gtk3
    ninja
    pkgconfig
    virtualgl # for viewing GL over ssh

    # latex support
    texlive.combined.scheme-small
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  # Testing go libp2p chat
  networking.firewall.allowedTCPPorts = [ 3001 ];

  # Nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
