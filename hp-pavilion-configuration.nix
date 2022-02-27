{ config, pkgs, ... }:

{
  boot = {
    # Use newer kernel for wifi support
    # kernelPackages = pkgs.linuxPackages_testing;
    # The rtw88_8821ce module kind of stinks
    blacklistedKernelModules = [
      "rtw88_8821ce"
    ];
    extraModulePackages = [
      #pkgs.linuxPackages_latest.rtl8821ce
      pkgs.linuxPackages.rtl8821ce
    ];
    #kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "hpbox";

  environment.systemPackages = with pkgs; [
    # Gui
    discord
    etcher
    filezilla
    gparted
    libreoffice
    qbittorrent
    reaper
    sakura
    vlc
    zettlr
    zoom-us

    # Terminal utilities
    file # Provide information about a file
    gnupg
    html-tidy # Formatter for HTML
    mono # open source dotnet framework implementation
    neovim-remote
    nerdfonts # fonts for terminal
    nnn # terminal file manager
    omnisharp-roslyn # C# linting engine
    pandoc # universal document converter
    python
    python39Packages.sqlparse # For vim SQL formatting
    ripgrep
    ripgrep-all
    screen # terminal multiplexer
    sqlint
    universal-ctags
    unzip
    usbutils
    w3m # terminal web browser
    zip

    # programming
    arduino
    arduino-cli
    dart
    dotnet-sdk
    flutter
    gcc
    gdb
    nodejs

    # General rust development
    rust-analyzer

    # Rust embedded development
    cargo-binutils
    cargo-generate
    openocd

    # Rust wasm
    wasm-pack

    # latex support
    texlive.combined.scheme-small
  ];
}
