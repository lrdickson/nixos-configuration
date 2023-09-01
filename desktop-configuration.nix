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
    # desktopManager.gnome.enable = true;
    # desktopManager.plasma5.enable = true;
    displayManager.gdm.enable = true;
    # displayManager.sddm.enable = true;
    # displayManager.defaultSession = if options.sway then "plasma" else "sway";
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
  programs.thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];

  environment.systemPackages = with pkgs; [
    # NTFS driver
    ntfs3g

    # Terminal applications
    distrobox
    xclip
    xorg.xhost # For allowing root applications to display GUIs

    # xfce
    #xfce.xfce4-whiskermenu-plugin

    # Desktop stuff
    #libsForQt5.filelight
    #libsForQt5.okular
    pinentry-gtk2
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

  # Add Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
