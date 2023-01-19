{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.networkmanager.enable = true;

  # Setup x
  #programs.xwayland.enable = true;
  services.xserver = {
    enable = true;
    desktopManager = {
      #cinnamon.enable = true;
      #gnome.enable = true;
      #plasma5.enable = true;
      xfce.enable = true;
      xterm.enable = false;
    };
    #displayManager.gdm.enable = true;
    #displayManager.defaultSession = "gnome";
    displayManager.defaultSession = "xfce";
    #displayManager.gdm.wayland = true;
    libinput.touchpad.tapping = false;
  };
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
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;

  # Gnome settings daemon
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  environment.systemPackages = with pkgs; [
    # NTFS driver
    ntfs3g

    # Terminal applications
    xclip

    # Gnome extensions
    #gnomeExtensions.appindicator
    #gnomeExtensions.dash-to-dock

    # xfce
    xfce.xfce4-whiskermenu-plugin

    # Desktop stuff
    brave
    chromium
    firefox
    libsForQt5.filelight
    libsForQt5.okular
    nextcloud-client
    pinentry-gtk2
    qutebrowser
    sakura
    xsane # For scanning
    gnome.simple-scan

    # pass
    pass
    qtpass

    glxinfo # GL testing
  ];

  # Add Nix Flakes
  #nix = {
    #package = pkgs.nixUnstable;
    #extraOptions = ''
      #experimental-features = nix-command flakes
    #'';
   #};
}
