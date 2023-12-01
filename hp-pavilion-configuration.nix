{ pkgs, ... }:
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

  services.logind = {
      lidSwitch = "suspend-then-hibernate";
      extraConfig = ''
        # don’t shutdown when power button is short-pressed
        HandlePowerKey=suspend-then-hibernate
      '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  networking.hostName = "hpbox";

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # Gui
    gnome.gnome-software # software manager - here for flatpak
    gparted
    nextcloud-client # The flatpak version can't open browsers

    # Terminal utilities
    acpi # battery monitoring cli
    bitwarden-cli
    cargo
    file # Provide information about a file
    gnupg
    nnn # terminal file manager
    nushell
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
    cloc
    clang
    clang-tools
    flutter
    go
    gopls
    gotools
    nodejs # needed for Coc

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
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "lyn" ];

}
