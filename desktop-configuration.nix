{ pkgs, ... }:

{
  # Linux zen kernel for better latency
  # boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Gnome settings daemon
  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  security.polkit.enable = true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  #extraPackages = [ pkgs.mesa.drivers ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  programs.system-config-printer.enable = true;

  # Enable scanning
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio # needed for pactl
    pulseaudio-ctl

    # filessystem drivers
    ntfs3g
    jmtpfs # For android file mount

    # Terminal applications
    acpi # battery monitoring cli
    distrobox
    xsel
    xorg.xhost # For allowing root applications to display GUIs
    usbutils
    pandoc # universal document converter
    poppler_utils
    ripgrep-all
    texlive.combined.scheme-small # latex support

    # Desktop stuff
    bitwarden-desktop
    obsidian
    pinentry-gtk2
    wezterm
    xdg-utils # for opening default programs when clicking links

    # Packages for canon printer
    canon-cups-ufr2
    cups-bjnp
    carps-cups
    gutenprintBin
    simple-scan
    kdePackages.skanlite
  ];

  fonts.packages = with pkgs; [
    cantarell-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # nerdfonts
    unifont

    font-awesome
  ];

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    # Gnome also comes with xdg-desktop-portal-gtk
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Add Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
