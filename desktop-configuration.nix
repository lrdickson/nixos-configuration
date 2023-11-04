{ config, pkgs, ... }:

let
options = import ./defaultOptions.nix // import ./options.nix;
in

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio" ];
  };

  # Linux zen kernel for better latency
  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.xserver = {
    enable = true;
  };

  # Gnome settings daemon
  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  networking.networkmanager.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  #extraPackages = [ pkgs.mesa.drivers ];

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
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = if options.sway then false else true;
    # enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin thunar-volman
  ];

  environment.systemPackages = with pkgs; [
    pulseaudio # needed for pactl

    # filessystem drivers
    ntfs3g
    jmtpfs # For android file mount

    # Terminal applications
    distrobox
    xclip
    xorg.xhost # For allowing root applications to display GUIs

    # xfce
    #xfce.xfce4-whiskermenu-plugin

    # Desktop stuff
    #libsForQt5.filelight
    #libsForQt5.okular
    alacritty
    pinentry-gtk2
    xdg-utils # for opening default programs when clicking links
  ];

  fonts.fonts = with pkgs; [
    cantarell-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerdfonts
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
