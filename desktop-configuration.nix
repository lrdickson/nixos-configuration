{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio" ];
  };

  networking.networkmanager.enable = true;

  # Setup x
  programs.xwayland.enable = true;
  services.xserver = {
    enable = true;
    desktopManager = {
      cinnamon.enable = true;
      #gnome.enable = true;
      #plasma5.enable = true;
      #xfce.enable = true;
      xterm.enable = false;
    };
    displayManager.defaultSession = "cinnamon";
    #displayManager.gdm.wayland = true;
    libinput.touchpad.tapping = false;
  };
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  programs.system-config-printer.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    # NTFS driver
    ntfs3g

    # Terminal applications
    xclip

    # Desktop stuff
    brave
    chromium
    firefox
    libsForQt5.okular
    minecraft
    pinentry-gtk2
    qutebrowser
    sakura

    # rust
    cargo
    rustc
    rustup

    # pass
    pass
    qtpass
  ];

  # Steam
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Add Nix Flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
}
